from django.shortcuts import get_object_or_404
from rest_framework import generics
from rest_framework.views import APIView, Response, status
from rest_framework_simplejwt.authentication import JWTStatelessUserAuthentication
from user_management.permissions import IsSuper_University_Campus_Department
from .models import CourseInformation, CourseSchedule, CourseObjective, CourseAssessment, CourseBooks, CourseLearningOutcomes, CourseOutline, WeeklyTopic
from .serializers import CourseInformationSerializer, CourseScheduleSerializer, CourseObjectiveSerializer, CourseObjectiveListSerializer, CourseAssessmentSerializer, CourseBookSerializer, CourseLearningOutcomesSerializer, CourseOutlineSerializer, WeeklyTopicSerializer, CompleteOutlineSerializer
from .utils import determine_clo_details
import openai
from rest_framework.decorators import api_view

# Create your views here.
class CourseInformationView(generics.ListCreateAPIView):
    queryset = CourseInformation.objects.all()
    serializer_class = CourseInformationSerializer
    permission_classes = [IsSuper_University_Campus_Department]
    authentication_classes = [JWTStatelessUserAuthentication]

class SingleCourseView(generics.RetrieveUpdateDestroyAPIView):
    queryset = CourseInformation.objects.all()
    serializer_class = CourseInformationSerializer
    permission_classes = [IsSuper_University_Campus_Department]
    authentication_classes = [JWTStatelessUserAuthentication]

class Course_of_Specific_Campus(generics.ListAPIView):
    serializer_class = CourseInformationSerializer
    permission_classes = [IsSuper_University_Campus_Department]
    authentication_classes = [JWTStatelessUserAuthentication]

    def get_queryset(self):
        pk = self.kwargs['pk']
        queryset = CourseInformation.objects.filter(campus__id=pk)
        return queryset
    
class CourseLearningOutcomesView(generics.CreateAPIView):
    queryset = CourseLearningOutcomes.objects.all()
    serializer_class = CourseLearningOutcomesSerializer
    permission_classes = [IsSuper_University_Campus_Department]
    authentication_classes = [JWTStatelessUserAuthentication]
    
    def create(self, request, *args, **kwargs):
        serializer = self.get_serializer(data=request.data)
        serializer.is_valid(raise_exception=True)
        self.perform_create(serializer)
        headers = self.get_success_headers(serializer.data)
        return Response(serializer.data, status=status.HTTP_201_CREATED, headers=headers)

class CLO_of_Specific_Course(generics.ListAPIView):
    serializer_class = CourseLearningOutcomesSerializer
    permission_classes = [IsSuper_University_Campus_Department]
    authentication_classes = [JWTStatelessUserAuthentication]

    def get_queryset(self):
        pk = self.kwargs['pk']
        queryset = CourseLearningOutcomes.objects.filter(course__id=pk)
        return queryset

class SingleCLO(generics.RetrieveUpdateDestroyAPIView):
    queryset = CourseLearningOutcomes.objects.all()
    serializer_class = CourseLearningOutcomesSerializer
    permission_classes = [IsSuper_University_Campus_Department]
    authentication_classes = [JWTStatelessUserAuthentication]



class CourseObjectiveCreateView(generics.CreateAPIView):
    queryset = CourseObjective.objects.all()
    serializer_class = CourseObjectiveSerializer
    permission_classes = [IsSuper_University_Campus_Department]
    authentication_classes = [JWTStatelessUserAuthentication]

    def create(self, request):
        serializer = self.get_serializer(data=request.data)
        is_valid = serializer.is_valid()
        if not is_valid:
            errors = serializer.errors  # Get validation errors
            return Response({"errors": errors}, status=status.HTTP_400_BAD_REQUEST)  # Send custom response with errors

        course = serializer.validated_data.get('course')
        descriptions = serializer.validated_data.get('description', [])

        if not isinstance(descriptions, list):
            return Response({"error": "Description must be a list"}, status=status.HTTP_400_BAD_REQUEST)

        for description in descriptions:
            if not isinstance(description, str):
                return Response({"error": "Each description must be a string"}, status=status.HTTP_400_BAD_REQUEST)
            
        if not descriptions:  # If descriptions list is empty
            return Response({"error": "Description can't be null"}, status=status.HTTP_400_BAD_REQUEST)
        
        for description in descriptions:
            CourseObjective.objects.create(course=course, description=description)

        return Response(serializer.data, status=status.HTTP_201_CREATED)

class CourseObjective_SpecificCourse_View(generics.ListAPIView):
    serializer_class = CourseObjectiveListSerializer
    permission_classes = [IsSuper_University_Campus_Department]
    authentication_classes = [JWTStatelessUserAuthentication]

    def get_queryset(self):
        pk = self.kwargs['pk']
        queryset = CourseObjective.objects.filter(course__id=pk)
        return queryset
    
class SingleCourseObjectiveView(generics.RetrieveUpdateDestroyAPIView):
    queryset = CourseObjective.objects.all()
    serializer_class = CourseObjectiveListSerializer
    permission_classes = [IsSuper_University_Campus_Department]
    authentication_classes = [JWTStatelessUserAuthentication]




class CourseOutlineCreateView(generics.CreateAPIView):
    queryset = CourseOutline.objects.all()
    serializer_class = CourseOutlineSerializer
    permission_classes = [IsSuper_University_Campus_Department]
    authentication_classes = [JWTStatelessUserAuthentication]

class CourseOutline_SpecificCourse_View(generics.ListAPIView):
    serializer_class = CourseOutlineSerializer
    permission_classes = [IsSuper_University_Campus_Department]
    authentication_classes = [JWTStatelessUserAuthentication]

    def get_queryset(self):
        pk = self.kwargs['pk']
        queryset = CourseOutline.objects.filter(course__id=pk)
        return queryset
    
class CourseOutline_SpecificBatch_View(generics.ListAPIView):
    serializer_class = CourseOutlineSerializer
    permission_classes = [IsSuper_University_Campus_Department]
    authentication_classes = [JWTStatelessUserAuthentication]

    def get_queryset(self):
        pk = self.kwargs['pk']
        queryset = CourseOutline.objects.filter(batch__id=pk)
        return queryset

class CourseOutline_SpecificTeacher_View(generics.ListAPIView):
    serializer_class = CourseOutlineSerializer
    permission_classes = [IsSuper_University_Campus_Department]
    authentication_classes = [JWTStatelessUserAuthentication]

    def get_queryset(self):
        pk = self.kwargs['pk']
        queryset = CourseOutline.objects.filter(teacher__id=pk)
        return queryset

class SingleCourseOutlineView(generics.RetrieveUpdateDestroyAPIView):
    queryset = CourseOutline.objects.all()
    serializer_class = CourseOutlineSerializer
    permission_classes = [IsSuper_University_Campus_Department]
    authentication_classes = [JWTStatelessUserAuthentication]






class CourseScheduleCreateView(generics.CreateAPIView):
    queryset = CourseSchedule.objects.all()
    serializer_class = CourseScheduleSerializer
    permission_classes = [IsSuper_University_Campus_Department]
    authentication_classes = [JWTStatelessUserAuthentication]

class CourseSchedule_SpecificOutline_View(generics.ListAPIView):
    serializer_class = CourseScheduleSerializer
    permission_classes = [IsSuper_University_Campus_Department]
    authentication_classes = [JWTStatelessUserAuthentication]

    def get_queryset(self):
        pk = self.kwargs['pk']
        queryset = CourseSchedule.objects.filter(course_outline__id=pk)
        return queryset
    
class SingleCourseScheduleView(generics.RetrieveUpdateDestroyAPIView):
    queryset = CourseSchedule.objects.all()
    serializer_class = CourseScheduleSerializer
    permission_classes = [IsSuper_University_Campus_Department]
    authentication_classes = [JWTStatelessUserAuthentication]





class CourseAssessmentCreateView(generics.CreateAPIView):
    queryset = CourseAssessment.objects.all()
    serializer_class = CourseAssessmentSerializer
    permission_classes = [IsSuper_University_Campus_Department]
    authentication_classes = [JWTStatelessUserAuthentication]
    def create(self, request):
        # Check if 'clo' and 'description' are empty lists
        clo_list = request.data.get('clo', [])
        
        if not isinstance(clo_list, list):
            return Response({"message": "Invalid data format"}, status=status.HTTP_400_BAD_REQUEST)

        if not clo_list:
            return Response({"message": "'clo' cannot be empty"}, status=status.HTTP_400_BAD_REQUEST)

        return super().create(request)

class CourseAssessment_SpecificOutline_View(generics.ListAPIView):
    serializer_class = CourseAssessmentSerializer
    permission_classes = [IsSuper_University_Campus_Department]
    authentication_classes = [JWTStatelessUserAuthentication]

    def get_queryset(self):
        pk = self.kwargs['pk']
        queryset = CourseAssessment.objects.filter(course_outline__id=pk)
        return queryset
    
class SingleCourseAssessmentView(generics.RetrieveUpdateDestroyAPIView):
    queryset = CourseAssessment.objects.all()
    serializer_class = CourseAssessmentSerializer
    permission_classes = [IsSuper_University_Campus_Department]
    authentication_classes = [JWTStatelessUserAuthentication]






class CourseBookCreateView(generics.CreateAPIView):
    queryset = CourseBooks.objects.all()
    serializer_class = CourseBookSerializer
    permission_classes = [IsSuper_University_Campus_Department]
    authentication_classes = [JWTStatelessUserAuthentication]

class CourseBook_SpecificOutline_View(generics.ListAPIView):
    serializer_class = CourseBookSerializer
    permission_classes = [IsSuper_University_Campus_Department]
    authentication_classes = [JWTStatelessUserAuthentication]

    def get_queryset(self):
        pk = self.kwargs['pk']
        queryset = CourseBooks.objects.filter(course_outline__id=pk)
        return queryset
    
class SingleCourseBookView(generics.RetrieveUpdateDestroyAPIView):
    queryset = CourseBooks.objects.all()
    serializer_class = CourseBookSerializer
    permission_classes = [IsSuper_University_Campus_Department]
    authentication_classes = [JWTStatelessUserAuthentication]

class Text_CourseBook(generics.ListAPIView):
    serializer_class = CourseBookSerializer
    permission_classes = [IsSuper_University_Campus_Department]
    authentication_classes = [JWTStatelessUserAuthentication]
    def get_queryset(self):
        pk = self.kwargs['pk']
        queryset = CourseBooks.objects.filter(course_outline__id=pk, book_type='Text')
        return queryset

class Reference_CourseBook(generics.ListAPIView):
    serializer_class = CourseBookSerializer
    permission_classes = [IsSuper_University_Campus_Department]
    authentication_classes = [JWTStatelessUserAuthentication]
    def get_queryset(self):
        pk = self.kwargs['pk']
        queryset = CourseBooks.objects.filter(course_outline__id=pk, book_type='Reference')
        return queryset

class WeeklyTopicCreateView(generics.CreateAPIView):
    queryset = WeeklyTopic.objects.all()
    serializer_class = WeeklyTopicSerializer
    permission_classes = [IsSuper_University_Campus_Department]
    authentication_classes = [JWTStatelessUserAuthentication]

    def create(self, request):
        # Check if 'clo' and 'description' are empty lists
        clo_list = request.data.get('clo', [])
        
        if not isinstance(clo_list, list):
            return Response({"message": "Invalid data format"}, status=status.HTTP_400_BAD_REQUEST)

        if not clo_list:
            return Response({"message": "'clo' cannot be empty"}, status=status.HTTP_400_BAD_REQUEST)

        return super().create(request)

class WeeklyTopic_SpecificOutline_View(generics.ListAPIView):
    serializer_class = WeeklyTopicSerializer
    permission_classes = [IsSuper_University_Campus_Department]
    authentication_classes = [JWTStatelessUserAuthentication]

    def get_queryset(self):
        pk = self.kwargs['pk']
        queryset = WeeklyTopic.objects.filter(course_outline__id=pk)
        return queryset
    
class WeeklyTopicRetrieveUpdateDestroy(generics.RetrieveUpdateDestroyAPIView):
    queryset = WeeklyTopic.objects.all()
    serializer_class = WeeklyTopicSerializer
    permission_classes = [IsSuper_University_Campus_Department]
    authentication_classes = [JWTStatelessUserAuthentication]



class CompleteOutlineView(APIView):
    permission_classes = [IsSuper_University_Campus_Department]
    authentication_classes = [JWTStatelessUserAuthentication]
    def get(self, request, pk):
        outline = get_object_or_404(CourseOutline, id=pk)
        serialized_data =  CompleteOutlineSerializer(outline)
        return Response(serialized_data.data, status=status.HTTP_200_OK)
    

# views.py
from django.http import JsonResponse
from program_management.models import PEO, PLO, PEO_PLO_Mapping

def get_clo_plo_peo_mappings(request, course_id):
    data = []

    try:
        course = CourseInformation.objects.get(id=course_id)
    except CourseInformation.DoesNotExist:
        return JsonResponse({'error': 'Course not found'}, status=404)

    clos = CourseLearningOutcomes.objects.filter(course=course)
    for clo in clos:
        clo_plos = clo.plo.all()
        for plo in clo_plos:
            plo_peos = PEO_PLO_Mapping.objects.filter(plo=plo)
            for mapping in plo_peos:
                data.append({
                    'clo': clo.description,
                    'plo': plo.name,
                    'peo': mapping.peo.description,
                })
    
    return JsonResponse(data, safe=False)



# views.py
from rest_framework.views import APIView
from rest_framework.response import Response
from .utils import determine_clo_details
from .models import CourseLearningOutcomes

class clo_view(APIView):
    def post(self, request):
        clo_description = request.data['clo_description']
        domain, level, related_plos = determine_clo_details(clo_description)

        # plo_data = [{'name': plo.name, 'description': plo.description} for plo in related_plos]

        data = {
            'clo_description': clo_description,
            'domain': domain,
            'level': level,
            'related_plos': related_plos
        }

        return Response(data)
    


@api_view(['POST'])
def generate_weekly_topics(request, course_id):
    # Fetch the course information
    course = get_object_or_404(CourseInformation, id=course_id)
    objectives = CourseObjective.objects.filter(course=course)
    
    # Prepare the data to send to OpenAI
    course_data = {
        "course_description": course.description,
        "course_objectives": [obj.description for obj in objectives],
        "pec_content": course.pec_content
    }
    
    # Create the prompt for OpenAI
    prompt = f"""
    Generate a weekly breakdown of topics for a course with the following details:
    Course Description: {course_data['course_description']}
    Course Objectives: {', '.join(course_data['course_objectives'])}
    Content: {course_data['pec_content']}
    
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
    
    # Call OpenAI API to generate topics
    response = openai.Completion.create(
        engine="text-davinci-003",
        prompt=prompt,
        max_tokens=1000,
        temperature=0.7,
        n=1
    )
    
    # Parse the response
    generated_text = response.choices[0].text.strip()
    weekly_topics = generated_text.split("\n")
    
    # Save the topics in the database
    weekly_topics_objects = []
    for week, topic in enumerate(weekly_topics, start=1):
        if week != 8 and week != 16:  # Skip midterm and final exam weeks for topic creation
            week_number = week if week <= 7 else week - 1  # Adjust for week 8
            topic_title, topic_description = topic.split(": ")
            weekly_topic = WeeklyTopic(
                week_number=week_number,
                topic=topic_title.strip(),
                description=topic_description.strip(),
                course_outline=course
            )
            weekly_topics_objects.append(weekly_topic)
    
    WeeklyTopic.objects.bulk_create(weekly_topics_objects)
    
    # Serialize the saved weekly topics and return in response
    serialized_data = WeeklyTopicSerializer(weekly_topics_objects, many=True)
    return Response(serialized_data.data, status=status.HTTP_201_CREATED)
