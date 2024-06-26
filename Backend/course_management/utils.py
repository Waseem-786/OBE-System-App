import re
import nltk
from collections import defaultdict
from nltk.stem import PorterStemmer
from nltk.corpus import stopwords
import openai
import os
from django.shortcuts import get_object_or_404
from .models import CourseInformation, CourseObjective, CourseOutline, WeeklyTopic, CourseLearningOutcomes
from program_management.models import PLO
from university_management.models import Batch
from user_management.models import CustomUser

# Ensure NLTK data is downloaded
nltk.download('punkt')
nltk.download('stopwords')

# Initialize stemmer and stopwords
stemmer = PorterStemmer()
stop_words = set(stopwords.words('english'))

def process_text(text):
    tokens = nltk.word_tokenize(text.lower())
    filtered_tokens = [token for token in tokens if token not in stop_words]
    stemmed_tokens = [stemmer.stem(token) for token in filtered_tokens]
    return stemmed_tokens

# Define Bloom's Taxonomy keywords and process them
bloom_keywords = {
    'Cognitive': {
        'remember': process_text('define describe identify label list match name outline recall recognize reproduce select state repeat memorize'),
        'understand': process_text('comprehend convert defend distinguish estimate explain extend generalize infer interpret paraphrase predict rewrite summarize translate classify discuss review'),
        'apply': process_text('apply change compute construct demonstrate discover manipulate modify operate prepare produce relate show solve use execute implement'),
        'analyze': process_text('analyze break compare contrast diagram deconstruct differentiate discriminate illustrate outline relate select separate attribute organize'),
        'evaluate': process_text('appraise conclude criticize critique defend evaluate interpret justify summarize support assess decide'),
        'create': process_text('categorize combine compile compose create devise design generate organize plan rearrange reconstruct revise tell write invent produce'),
    },
    'Psychomotor': {
        'perception': process_text('choose describe detect differentiate distinguish identify isolate select sense sees'),
        'set': process_text('begin display explain move proceed react show state volunteer starts initiates'),
        'guided response': process_text('copy trace follow reproduce respond imitate practice'),
        'mechanism': process_text('assemble calibrate construct dismantle fasten fix grind manipulate measure mend mix organize sketch perform execute'),
        'complex overt response': process_text('build operate perform coordinate master excel'),
        'adaptation': process_text('adapt alter change rearrange revise vary modify'),
        'origination': process_text('arrange combine compose construct create design initiate originate innovate lead')
    },
    'Affective': {
        'receiving': process_text('ask choose describe follow give hold identify locate name select attend listen notice acknowledge receive'),
        'responding': process_text('answer assist aid comply discuss greet help label perform practice present read recite report tell write react respond'),
        'valuing': process_text('complete demonstrate differentiate explain follow form initiate invite join justify propose share study work appreciate value'),
        'organizing': process_text('adhere alter arrange combine compare defend formulate generalize integrate modify order prepare relate synthesize structure integrate'),
        'internalizing': process_text('act display influence listen perform practice question serve solve verify commit internalize')
    }
}

# Define keyword weights
keyword_weights = {
    'create': 3, 'present': 3, 'design': 3, 'analyze': 2, 'communicate': 3,
    'knowledge': 2, 'apply': 2, 'ethical': 3, 'team': 3, 'learning': 3
    # Add more as needed
}

def determine_bloom_domain_and_level(clo_description):
    tokens = process_text(clo_description)
    domain_scores = defaultdict(int)
    level_scores = defaultdict(lambda: defaultdict(int))

    for domain, levels in bloom_keywords.items():
        for level, keywords in levels.items():
            score = sum(keyword_weights.get(keyword, 1) * tokens.count(keyword) for keyword in keywords)
            if score > 0:
                domain_scores[domain] += score
                level_scores[domain][level] += score

    if domain_scores:
        best_domain = max(domain_scores, key=domain_scores.get)
        best_level = max(level_scores[best_domain], key=level_scores[best_domain].get)
        level_number = _convert_level_to_number(best_level)
        return best_domain, best_level, level_number
    return "Unknown", "Unknown", 0

def _convert_level_to_number(level):
    level_map = {
        'remember': 1,
        'understand': 2,
        'apply': 3,
        'analyze': 4,
        'evaluate': 5,
        'create': 6
    }
    return level_map.get(level.lower(), 0)

# Define PLO keywords
plos_keywords = {
    1: {'engineering', 'mathematics', 'science', 'fundamentals', 'specialization', 'knowledge'},
    2: {'analyze', 'formulate', 'identify', 'research', 'conclusions', 'mathematics', 'sciences'},
    3: {'design', 'development', 'solutions', 'systems', 'components', 'processes', 'health', 'safety'},
    4: {'investigate', 'experiments', 'analysis', 'data', 'synthesis', 'conclusions'},
    5: {'modern', 'tools', 'techniques', 'resources', 'modeling', 'prediction'},
    6: {'societal', 'health', 'safety', 'legal', 'cultural', 'contextual', 'responsibilities'},
    7: {'environment', 'sustainability', 'development', 'impact', 'societal'},
    8: {'ethics', 'ethical', 'responsibilities', 'norms'},
    9: {'teamwork', 'individual', 'multidisciplinary'},
    10: {'communication', 'reports', 'documentation', 'presentations', 'instructions'},
    11: {'management', 'projects', 'team', 'multidisciplinary'},
    12: {'learning', 'lifelong', 'innovation', 'technological'}
}

def get_related_plos(clo_description):
    clo_words = set(clo_description.lower().split())
    related_plos = []
    for plo_id, keywords in plos_keywords.items():
        if clo_words.intersection(keywords):
            related_plos.append(plo_id)
            
    return related_plos

def determine_clo_details(clo_description):
    domain, level, level_number = determine_bloom_domain_and_level(clo_description)
    related_plos = get_related_plos(clo_description)
    return domain, level, level_number, related_plos

def generate_clos_from_weekly_topics(course_outline_id, user_comments=""):
    course_outline = get_object_or_404(CourseOutline, id=course_outline_id)
    course = course_outline.course
    
    # Extract course information
    course_description = course.description
    course_objectives = [obj.description for obj in CourseObjective.objects.filter(course=course)]
    pec_content = course.pec_content
    
    # Extract weekly topics
    weekly_topics = WeeklyTopic.objects.filter(course_outline=course_outline).order_by('week_number')
    if not weekly_topics.exists():
        raise ValueError("No weekly topics found for this course outline.")
    topics_data = "\n".join([f"Week {topic.week_number}: {topic.topic} - {topic.description}" for topic in weekly_topics])
    
    # Extract all PLOs
    all_plos = PLO.objects.all()
    plo_descriptions = "\n".join([f"{plo.id}: {plo.description}" for plo in all_plos])
    
    # Prepare messages for the AI
    messages = [
        {"role": "system", "content": "Generate Course Learning Outcomes (CLOs) based on the course details, weekly topics, and PLOs provided."},
        {"role": "user", "content": f"""
            Course: {course.title}
            Course Description: {course_description}
            Course Objectives: {', '.join(course_objectives)}
            PEC Content: {pec_content}
            Weekly Topics: 
            {topics_data}
            PLOs:
            {plo_descriptions}
            Additional Comments: {user_comments}
            Please create CLOs that map to at least one of these PLOs and align with the weekly topics, but do not mention PLOs directly in the CLO statements.
        """}
    ]

    # OpenAI API key
    api_key = os.getenv('OPEN_AI_API')
    if not api_key:
        raise ValueError("API key is not set or invalid.")
    openai.api_key = api_key
    
    # Call OpenAI API
    try:
        response = openai.ChatCompletion.create(
            model="gpt-3.5-turbo",
            messages=messages,
            temperature=0.7
        )
    except openai.error.OpenAIError as e:
        raise ValueError(f"OpenAI API request failed: {str(e)}")
    
    if response['choices']:
        generated_text = response['choices'][0]['message']['content']
        # Clean up the generated CLOs text and remove any mention of PLOs
        cleaned_text = re.sub(r"^\d+\.\s*", "", generated_text, flags=re.MULTILINE)
        cleaned_text = re.sub(r"^Course Learning Outcomes:\s*", "", cleaned_text, flags=re.MULTILINE)
        cleaned_text = re.sub(r'\b(?:aligning with|relating to|mapping to|associated with) PLOs?.*', '', cleaned_text, flags=re.IGNORECASE)
        clos = [clo.strip() for clo in cleaned_text.split("\n") if clo.strip()]
        if "Course Learning Outcomes (CLOs):" in clos:
            clos.remove("Course Learning Outcomes (CLOs):")
    else:
        raise ValueError("OpenAI API response did not contain any choices.")
    
    # Return generated CLOs with details
    clos_data = []
    for clo in clos:
        domain, level, level_number, related_plos = determine_clo_details(clo)
        clos_data.append({
            "description": clo,
            "bloom_taxonomy": domain,
            "level": level_number,
            "plos": related_plos
        })
    
    return clos_data



def generate_weekly_topics(course_outline_id, user_comments):
    course_outline = get_object_or_404(CourseOutline, id=course_outline_id)
    objectives = CourseObjective.objects.filter(course=course_outline.course)

    course_data = {
        "course_description": course_outline.course.description,
        "course_objectives": [obj.description for obj in objectives],
        "pec_content": course_outline.course.pec_content
    }

    # Set up the initial system and user messages
    messages = [
        {"role": "system", "content": "Generate a detailed weekly breakdown of topics for the specified course details."},
        {"role": "user", "content": f"""
            Course Description: {course_data['course_description']}
            Course Objectives: {', '.join(course_data['course_objectives'])}
            Content: {course_data['pec_content']}
            Additional Comments: {user_comments}
            The course should have detailed topics for weeks 1-7, an exam in week 8, detailed topics for weeks 9-15, and a final exam in week 16.
            Each topic should include a title and a detailed description.
        """}
    ]

    api_key = os.getenv('OPEN_AI_API')
    if not api_key:
        raise ValueError("API key is not set or invalid.")

    openai.api_key = api_key
    try:
        response = openai.ChatCompletion.create(
            model="gpt-3.5-turbo",
            messages=messages,
            temperature=0.7
        )
    except openai.error.OpenAIError as e:
        raise ValueError(f"OpenAI API request failed: {str(e)}")

    if response['choices']:
        generated_text = response['choices'][0]['message']['content']
        weekly_topics = generated_text.split("\n")
    else:
        raise ValueError("OpenAI API response did not contain any choices.")

    # Process the generated text
    processed_topics = []
    current_topic = {}
    
    for line in weekly_topics:
        if line.startswith("Week "):
            if current_topic:
                processed_topics.append(current_topic)
                current_topic = {}
            current_topic['week_number'] = int(re.search(r'\d+', line).group())
        elif line.startswith("Topic: "):
            current_topic['topic'] = line.replace("Topic: ", "").strip()
        elif line.startswith("Description: "):
            current_topic['description'] = line.replace("Description: ", "").strip()

    if current_topic:
        processed_topics.append(current_topic)
    
    return processed_topics
