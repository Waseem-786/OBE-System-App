import openai
import os
from .models import PEO
from university_management.models import University, Campus, Department
from django.shortcuts import get_object_or_404
import spacy
from rest_framework.exceptions import APIException

# Set the OpenAI API key from environment variable
openai.api_key = os.getenv('OPENAI_API_KEY')

nlp = spacy.load('en_core_web_lg')  # Load the model outside the function to save loading time

def check_peo_consistency(peo_id, department_id):
    department = get_object_or_404(Department, id=department_id)
    campus = department.campus
    university = campus.university
    peo = get_object_or_404(PEO, id=peo_id)

    vision_mission_texts = {
        "University Vision": university.vision,
        "University Mission": university.mission,
        "Campus Vision": campus.vision,
        "Campus Mission": campus.mission,
        "Department Vision": department.vision,
        "Department Mission": department.mission
    }

    inconsistencies = []

    for title, text in vision_mission_texts.items():
        if text:  # Check if text is not None
            doc_base = nlp(text)
            doc_peo = nlp(peo.description)
            similarity = doc_base.similarity(doc_peo)
            if similarity < 0.8:
                inconsistencies.append(title)

    return inconsistencies

def get_peo_suggestions(peo_description, vision_mission_texts):
    try:
        prompt_parts = [
            f"{title}:\n{text}\n" for title, text in vision_mission_texts.items() if text
        ]
        prompt = f"Based on the following vision and mission statements:\n\n{''.join(prompt_parts)}\nProvide suggestions to refine the following PEO to make it more consistent:\n\n{peo_description}"
        
        response = openai.ChatCompletion.create(
            model="gpt-3.5-turbo",
            messages=[
                {"role": "system", "content": "You are a helpful assistant refining text to professional standards."},
                {"role": "user", "content": prompt}
            ]
        )
        suggestions = response['choices'][0]['message']['content'].strip()
        return suggestions
    except openai.error.OpenAIError as e:
        print("Error:", str(e))
        return peo_description  # Return the original text if the API call fails
