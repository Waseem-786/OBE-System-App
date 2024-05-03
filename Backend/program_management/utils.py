from collections import Counter
import re
from nltk.corpus import stopwords


# def map_peos_to_vision(vision, peos):
#     # Preprocess the text by removing punctuation and converting to lowercase
#     vision_words = re.findall(r'\w+', vision.lower())
#     vision_counter = Counter(vision_words)
    
#     # Get English stopwords
#     stop_words = set(stopwords.words('english'))
    
#     # Create a dictionary to hold the mapping results
#     mapping = {}
    
#     # Iterate over each PEO object
#     for index, peo in enumerate(peos):
#         peo_description = peo.description.lower()
        
#         # Remove stop words from PEO description
#         peo_words = [word for word in re.findall(r'\w+', peo_description) if word not in stop_words]
        
#         # Find words in the PEO description that are also in the vision statement
#         common_words = [word for word in peo_words if vision_counter[word] > 0]
        
#         # Add the common words to the mapping dictionary using the index as a key
#         mapping[f'PEO {index + 1}'] = common_words
    
#     return mapping





# from nltk.corpus import wordnet as wn

# def get_synonyms(word):
#     synonyms = set()
#     for synset in wn.synsets(word):
#         for lemma in synset.lemmas():
#             synonyms.add(lemma.name())
#     return list(synonyms)

# def map_peos_to_vision(vision, peos):
#     # Preprocess the text by removing punctuation and converting to lowercase
#     vision_words = re.findall(r'\w+', vision.lower())
#     vision_counter = Counter(vision_words)
    
#     # Get English stopwords
#     stop_words = set(stopwords.words('english'))
    
#     # Create a dictionary to hold the mapping results
#     mapping = {}
    
#     # Iterate over each PEO object
#     for index, peo in enumerate(peos):
#         peo_description = peo.description.lower()
        
#         # Remove stop words from PEO description
#         peo_words = [word for word in re.findall(r'\w+', peo_description) if word not in stop_words]
        
#         # Find words in the PEO description that are also in the vision statement
#         common_words = []
#         for word in peo_words:
#             synonyms = get_synonyms(word)
#             common_words.extend([synonym for synonym in synonyms if synonym in vision_counter])
        
#         # Add the common words to the mapping dictionary using the index as a key
#         mapping[f'PEO {index + 1}'] = common_words
    
#     return mapping









import spacy

def find_similar_words(paragraph, text):
    # Load the large English model with word vectors
    nlp = spacy.load('en_core_web_lg')

    # Process the paragraph
    doc = nlp(paragraph)

    # Split text into words and filter out common words
    words = [token.text for token in nlp(text) if not token.is_stop and token.is_alpha]

    # Find similar words for each word in the text
    similar_words = {}
    for word in words:
        # Process each word with spaCy
        search_word = nlp(word)[0]
        similar_words[word] = []
        for token in doc:
            # Calculate similarity using word vectors
            similarity = search_word.similarity(token)
            if similarity > 0.8:  # You can adjust the threshold
                similar_words[word].append(token.text)

    return similar_words
