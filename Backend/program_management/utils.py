import openai
import os
from django.shortcuts import get_object_or_404
from .models import Department

def generate_peos(department_id, num_peos, additional_message=None):
    department = get_object_or_404(Department, id=department_id)
    campus = department.campus
    university = campus.university

    # Prepare the chat messages for the AI
    messages = [
        {"role": "system", "content": "You are an assistant that generates educational objectives."},
        {"role": "user", "content": f"""
            Generate {num_peos} educational objectives aligned with these details:
            University Vision: {university.vision}
            University Mission: {university.mission}
            Campus Vision: {campus.vision}
            Campus Mission: {campus.mission}
            Department Vision: {department.vision}
            Department Mission: {department.mission}
        """}
    ]

    if additional_message:
        messages.append({"role": "user", "content": f"Additional instructions: {additional_message}"})

    api_key = os.getenv('OPEN_AI_API')
    if not api_key:
        return {"status": "error", "message": "API key is not set or invalid."}

    openai.api_key = api_key
    try:
        response = openai.ChatCompletion.create(
            model="gpt-3.5-turbo",
            messages=messages,
            max_tokens=200 * num_peos
        )
        peos = response['choices'][0]['message']['content'].strip()
        return {"status": "success", "peos": peos}
    except openai.error.OpenAIError as e:
        return {"status": "error", "message": str(e)}




def refine_statement(statement_type, statement, additional_message=None):
    openai_api_key = os.getenv("OPEN_AI_API")
    if not openai_api_key:
        return {"status": "error", "message": "OpenAI API key not found in environment variables."}

    openai.api_key = openai_api_key

    # Prepare the chat messages
    messages = [
        {"role": "system", "content": "You are an assistant that refines vision and mission statements."},
        {"role": "user", "content": f"Please refine this {statement_type} statement to be more impactful: '{statement}'"}
    ]

    if additional_message:
        messages.append({"role": "user", "content": f"Additional instructions: {additional_message}"})

    try:
        response = openai.ChatCompletion.create(
            model="gpt-3.5-turbo",
            messages=messages,
            max_tokens=150
        )
        refined_statement = response['choices'][0]['message']['content'].strip()
        return {"status": "success", "refined_statement": refined_statement}
    except openai.Error as e:
        return {"status": "error", "message": f"OpenAI API error: {str(e)}"}
    


import nltk
from nltk.corpus import stopwords
from nltk.tokenize import word_tokenize
from nltk import download
from .models import Department

download('punkt')
download('stopwords')

def tokenize_and_filter(text):
    stop_words = set(stopwords.words('english'))
    word_tokens = word_tokenize(text)
    filtered_words = [w for w in word_tokens if not w.lower() in stop_words and w.isalpha()]
    return set(filtered_words)

def check_peo_consistency(department_id):
    try:
        department = Department.objects.get(id=department_id)
        campus = department.campus
        university = campus.university

        # Extract keywords
        uni_vision_keywords = tokenize_and_filter(university.vision)
        uni_mission_keywords = tokenize_and_filter(university.mission)
        camp_vision_keywords = tokenize_and_filter(campus.vision)
        camp_mission_keywords = tokenize_and_filter(campus.mission)
        dept_vision_keywords = tokenize_and_filter(department.vision)
        dept_mission_keywords = tokenize_and_filter(department.mission)

        # Assume PEOs are stored in a field or related model accessible as a text field or list
        peos = [peo.description for peo in department.peo_set.all()]
        results = {}

        for idx, peo in enumerate(peos):
            peo_keywords = tokenize_and_filter(peo)
            total_keywords = len(peo_keywords)

            # Check consistency with keywords and calculate percentage
            consistency = {
                'uni_vision': {
                    "overlap": len(uni_vision_keywords & peo_keywords),
                    "total": len(uni_vision_keywords),
                    "percentage": (len(uni_vision_keywords & peo_keywords) / total_keywords * 100) if total_keywords > 0 else 0
                },
                'uni_mission': {
                    "overlap": len(uni_mission_keywords & peo_keywords),
                    "total": len(uni_mission_keywords),
                    "percentage": (len(uni_mission_keywords & peo_keywords) / total_keywords * 100) if total_keywords > 0 else 0
                },
                'camp_vision': {
                    "overlap": len(camp_vision_keywords & peo_keywords),
                    "total": len(camp_vision_keywords),
                    "percentage": (len(camp_vision_keywords & peo_keywords) / total_keywords * 100) if total_keywords > 0 else 0
                },
                'camp_mission': {
                    "overlap": len(camp_mission_keywords & peo_keywords),
                    "total": len(camp_mission_keywords),
                    "percentage": (len(camp_mission_keywords & peo_keywords) / total_keywords * 100) if total_keywords > 0 else 0
                },
                'dept_vision': {
                    "overlap": len(dept_vision_keywords & peo_keywords),
                    "total": len(dept_vision_keywords),
                    "percentage": (len(dept_vision_keywords & peo_keywords) / total_keywords * 100) if total_keywords > 0 else 0
                },
                'dept_mission': {
                    "overlap": len(dept_mission_keywords & peo_keywords),
                    "total": len(dept_mission_keywords),
                    "percentage": (len(dept_mission_keywords & peo_keywords) / total_keywords * 100) if total_keywords > 0 else 0
                }
            }
            results[f'PEO {idx + 1}'] = consistency

        return results
    except Department.DoesNotExist:
        return {"error": "Department not found."}
