import openai
import os
from .models import Department

import openai
import os
from .models import Department

def generate_peos(department_id, num_peos, additional_message=None):
    try:
        # Fetch the department and related entities
        department = Department.objects.get(id=department_id)
        campus = department.campus
        university = campus.university

        # Prepare the input prompt for the AI
        prompt = (
            f"Generate {num_peos} educational objectives that align with the following vision and mission statements:\n"
            f"University Vision: {university.vision}\n"
            f"University Mission: {university.mission}\n"
            f"Campus Vision: {campus.vision}\n"
            f"Campus Mission: {campus.mission}\n"
            f"Department Vision: {department.vision}\n"
            f"Department Mission: {department.mission}\n"
            f"These objectives should be concise, measurable, achievable, relevant, and time-bound."
        )

        if additional_message:
            prompt += f"\nAdditional instructions: {additional_message}"

        # Call OpenAI API
        api_key = os.getenv('OPEN_AI_API')
        if not api_key:
            return {"status": "error", "message": "API key is not set or invalid."}

        openai.api_key = api_key
        response = openai.Completion.create(
            engine="text-davinci-003",
            prompt=prompt,
            max_tokens=200 * num_peos  # Assuming about 200 tokens per PEO
        )
        peos = response.choices[0].text.strip()

        return {"status": "success", "peos": peos}
    except Department.DoesNotExist:
        return {"status": "error", "message": "Department not found."}
    except openai.Error as e:
        return {"status": "error", "message": f"OpenAI API error: {str(e)}"}
    except Exception as e:
        return {"status": "error", "message": f"An unexpected error occurred: {str(e)}"}



def refine_statement(statement_type, statement, additional_message=None):
    """
    Refines a vision or mission statement using OpenAI's GPT.

    Args:
    statement_type (str): 'vision' or 'mission' indicating the type of statement.
    statement (str): The vision or mission statement to be refined.
    additional_message (str): Optional additional instructions or context for the refinement.

    Returns:
    dict: A dictionary containing the 'status' and 'message' or 'refined_statement'.
    """
    openai_api_key = os.getenv("OPEN_AI_API")
    if not openai_api_key:
        return {"status": "error", "message": "OpenAI API key not found in environment variables."}

    openai.api_key = openai_api_key

    # Setting the prompt based on statement type
    if statement_type.lower() == 'vision':
        prompt = f"Refine this vision statement to be more inspiring and forward-looking: '{statement}'"
    elif statement_type.lower() == 'mission':
        prompt = f"Refine this mission statement to be more clear and actionable: '{statement}'"
    else:
        return {"status": "error", "message": "Invalid statement type. Please choose 'vision' or 'mission'."}

    if additional_message:
        prompt += f" Additional instructions: {additional_message}"

    try:
        response = openai.Completion.create(
            engine="text-davinci-003",  # or another suitable model
            prompt=prompt,
            max_tokens=150  # Adjusted to allow for longer inputs with additional instructions
        )
    except openai.Error as e:
        return {"status": "error", "message": f"OpenAI API error: {str(e)}"}
    except Exception as e:
        return {"status": "error", "message": f"An unexpected error occurred: {str(e)}"}

    # Check response status
    if response['choices'] and response['choices'][0].text.strip():
        return {"status": "success", "refined_statement": response.choices[0].text.strip()}
    else:
        return {"status": "error", "message": "Failed to refine the statement due to an empty response."}
    


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
