import nltk
from collections import defaultdict
from nltk.stem import PorterStemmer
from nltk.corpus import stopwords
import openai
import os
from django.shortcuts import get_object_or_404
from .models import CourseInformation, CourseObjective, CourseOutline, WeeklyTopic
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
        'origination': process_text('arrange combine compose construct create design initiate originate innvate lead')
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
        return best_domain, best_level
    return "Unknown", "Unknown"

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
    domain, level = determine_bloom_domain_and_level(clo_description)
    related_plos = get_related_plos(clo_description)
    return domain, level, related_plos


def generate_weekly_topics(course_id, teacher_id, batch_id, user_comments):
    course = get_object_or_404(CourseInformation, id=course_id)
    teacher = get_object_or_404(CustomUser, id=teacher_id)
    batch = get_object_or_404(Batch, id=batch_id)
    objectives = CourseObjective.objects.filter(course=course)
    course_outline = get_object_or_404(CourseOutline, course=course, teacher=teacher, batch=batch)

    course_data = {
        "course_description": course.description,
        "course_objectives": [obj.description for obj in objectives],
        "pec_content": course.pec_content
    }

    prompt = f"""
    Generate a weekly breakdown of topics for a course with the following details:
    Course Description: {course_data['course_description']}
    Course Objectives: {', '.join(course_data['course_objectives'])}
    Content: {course_data['pec_content']}
    
    Additional Comments: {user_comments}
    
    The course should have topics for weeks 1-7, an exam in week 8, topics for weeks 9-15, and a final exam in week 16.
    
    Week 1: 
    Week 2: 
    Week 3: 
    Week 4: 
    Week 5: 
    Week 6: 
    Week 7: 
    Week 8: Midterm Exam
    Week 9: 
    Week 10: 
    Week 11: 
    Week 12: 
    Week 13: 
    Week 14: 
    Week 15: 
    Week 16: Final Exam
    """

    api_key = os.getenv('OPEN_AI_API')
    if not api_key:
        raise ValueError("API key is not set or invalid.")

    openai.api_key = api_key
    try:
        response = openai.Completion.create(
            engine="text-davinci-003",
            prompt=prompt,
            max_tokens=1000,
            temperature=0.7,
            n=1
        )
    except openai.error.OpenAIError as e:
        raise ValueError(f"OpenAI API request failed: {str(e)}")

    if response.choices:
        generated_text = response.choices[0].text.strip()
        weekly_topics = generated_text.split("\n")
    else:
        raise ValueError("OpenAI API response did not contain any choices.")

    WeeklyTopic.objects.filter(course_outline=course_outline).delete()

    weekly_topics_objects = []
    for week, topic in enumerate(weekly_topics, start=1):
        if week != 8 and week != 16:
            week_number = week if week <= 7 else week - 1
            if ": " in topic:
                topic_title, topic_description = topic.split(": ", 1)
                weekly_topic = WeeklyTopic(
                    week_number=week_number,
                    topic=topic_title.strip(),
                    description=topic_description.strip(),
                    course_outline=course_outline
                )
                weekly_topics_objects.append(weekly_topic)

    WeeklyTopic.objects.bulk_create(weekly_topics_objects)
    
    return weekly_topics_objects
