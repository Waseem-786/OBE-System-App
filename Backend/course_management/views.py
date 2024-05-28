from django.shortcuts import get_object_or_404
from rest_framework import generics
from rest_framework.views import APIView, Response, status
from rest_framework_simplejwt.authentication import JWTStatelessUserAuthentication
from user_management.permissions import IsSuper_University_Campus_Department
from .models import CourseInformation, CourseSchedule, CourseObjective, CourseAssessment, CourseBooks, CourseLearningOutcomes, CourseOutline, WeeklyTopic
from .serializers import CourseInformationSerializer, CourseScheduleSerializer, CourseObjectiveSerializer, CourseObjectiveListSerializer, CourseAssessmentSerializer, CourseBookSerializer, CourseLearningOutcomesSerializer, CourseOutlineSerializer, WeeklyTopicSerializer, CompleteOutlineSerializer

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
