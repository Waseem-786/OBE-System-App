import openai
import os
from collections import defaultdict
from .models import CourseLearningOutcomes
from course_management.utils import process_text, bloom_keywords

def check_question_consistency(question_description, clo_ids):
    """
    Check if the question description is consistent with the selected CLOs.
    """
    # Fetch the selected CLOs
    clos = CourseLearningOutcomes.objects.filter(id__in=clo_ids)
    
    if not clos.exists():
        return {
            "status": "error",
            "message": "No CLOs found for the provided IDs.",
            "consistent": False
        }
    
    # Process the question description
    question_tokens = process_text(question_description)
    
    # Initialize a dictionary to store the scores for each domain and level
    domain_scores = defaultdict(int)
    level_scores = defaultdict(lambda: defaultdict(int))

    for clo in clos:
        # Get the keywords for the CLO's domain and level
        domain = clo.bloom_taxonomy
        level = clo.level
        keywords = bloom_keywords[domain].get(level, [])
        
        if not keywords:
            continue
        
        # Calculate the score for the question based on the CLO's keywords
        score = sum(question_tokens.count(keyword) for keyword in keywords)
        domain_scores[domain] += score
        level_scores[domain][level] += score

    # Check if the question is consistent with any of the selected CLOs
    consistent = any(score > 0 for score in domain_scores.values())
    if consistent:
        return {
            "status": "success",
            "message": "The question is consistent with the selected CLOs.",
            "consistent": True
        }
    else:
        return {
            "status": "warning",
            "message": "The question is not consistent with the selected CLOs.",
            "consistent": False
        }

def convert_question_with_clos(question_description, clo_ids):
    """
    Convert the question to be consistent with the selected CLOs using AI.
    """
    # Fetch the selected CLOs
    clos = CourseLearningOutcomes.objects.filter(id__in=clo_ids)
    
    if not clos.exists():
        return {
            "status": "error",
            "message": "No CLOs found for the provided IDs."
        }
    
    # Prepare the CLO details for the prompt
    clo_details = [
        f"{clo.bloom_taxonomy} - Level {clo.level}: {clo.description}" for clo in clos
    ]
    clo_details_str = "\n".join(clo_details)
    
    # Create the prompt for OpenAI
    prompt = f"""
    The following question needs to be consistent with the provided CLOs:
    
    Question: {question_description}
    
    CLOs:
    {clo_details_str}
    
    Please rewrite the question to ensure it aligns with the given CLOs.
    """
    
    # Call OpenAI API
    api_key = os.getenv('OPEN_AI_API')
    if not api_key:
        return {
            "status": "error",
            "message": "API key is not set or invalid."
        }

    try:
        openai.api_key = api_key
        response = openai.Completion.create(
            engine="text-davinci-003",
            prompt=prompt,
            max_tokens=500,
            temperature=0.7,
            n=1
        )
    except openai.error.OpenAIError as e:
        return {
            "status": "error",
            "message": str(e)
        }
    
    # Parse the response
    generated_text = response.choices[0].text.strip()
    return {
        "status": "success",
        "converted_question": generated_text
    }
