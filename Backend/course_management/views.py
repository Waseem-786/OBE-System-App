from django.shortcuts import get_object_or_404
from rest_framework import generics
from rest_framework.views import APIView, Response, status
from rest_framework_simplejwt.authentication import JWTStatelessUserAuthentication
from user_management.permissions import IsSuper_University_Campus_Department
from .models import CourseInformation, CourseSchedule, CourseObjective, CourseAssessment, CourseBooks, CourseLearningOutcomes, CourseOutline, WeeklyTopic
from .serializers import CourseInformationSerializer, CourseScheduleSerializer, CourseObjectiveSerializer, CourseObjectiveListSerializer, CourseAssessmentSerializer, CourseBookSerializer, CourseLearningOutcomesSerializer, CourseOutlineSerializer, WeeklyTopicSerializer, CompleteOutlineSerializer
from .utils import determine_clo_details, generate_weekly_topics, generate_clos_from_weekly_topics
from approval_process.models import ApprovalProcess, ApprovalLog, ApprovalStep

# CLO and PLO Mapping View
from django.http import JsonResponse
from program_management.models import PEO, PLO, PEO_PLO_Mapping

# Course Information Views
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

class CLOUpdateView(APIView):
    # Uncomment these lines if you want to enable authentication and permissions
    # permission_classes = [IsSuper_University_Campus_Department]
    # authentication_classes = [JWTStatelessUserAuthentication]

    def post(self, request, course_outline_id):
        update_clos = request.data.get('update_clos', False)
        user_justification = request.data.get('justification', '')

        if not user_justification:
            return Response({"error": "Justification is required."}, status=status.HTTP_400_BAD_REQUEST)

        if update_clos:
            user_comments = request.data.get('user_comments', '')

            try:
                clos = generate_clos_from_weekly_topics(course_outline_id, user_comments)
                course_outline = get_object_or_404(CourseOutline, id=course_outline_id)
                previous_clos = CourseLearningOutcomes.objects.filter(course=course_outline.course)


                # Create an approval process for the update
                for clo in clos:
                    initial_step = ApprovalStep.objects.first()  # Assuming steps are predefined and ordered
                    if initial_step:
                        ApprovalProcess.objects.create(clo=clo, current_step=initial_step, justification=user_justification)
                    else:
                        return Response({"error": "No approval steps defined."}, status=status.HTTP_400_BAD_REQUEST)

                serialized_previous_clos = CourseLearningOutcomesSerializer(previous_clos, many=True).data
                serialized_new_clos = CourseLearningOutcomesSerializer(clos, many=True).data

                response_data = {
                    'previous_clos': serialized_previous_clos,
                    'new_clos': serialized_new_clos,
                    'justification': user_justification
                }

                return Response(response_data, status=status.HTTP_200_OK)
            except ValueError as e:
                return Response({"error": str(e)}, status=status.HTTP_400_BAD_REQUEST)
            except Exception as e:
                return Response({"error": "An unexpected error occurred: " + str(e)}, status=status.HTTP_500_INTERNAL_SERVER_ERROR)
        else:
            course_outline = get_object_or_404(CourseOutline, id=course_outline_id)
            clos = CourseLearningOutcomes.objects.filter(course=course_outline.course)

            serialized_clos = CourseLearningOutcomesSerializer(clos, many=True)
            return Response(serialized_clos.data, status=status.HTTP_200_OK)

# Course Objectives Views
class CourseObjectiveCreateView(generics.CreateAPIView):
    queryset = CourseObjective.objects.all()
    serializer_class = CourseObjectiveSerializer
    permission_classes = [IsSuper_University_Campus_Department]
    authentication_classes = [JWTStatelessUserAuthentication]

    def create(self, request):
        serializer = self.get_serializer(data=request.data)
        is_valid = serializer.is_valid()
        if not is_valid:
            errors = serializer.errors
            return Response({"errors": errors}, status=status.HTTP_400_BAD_REQUEST)
        
        course = serializer.validated_data.get('course')
        descriptions = serializer.validated_data.get('description', [])
        
        if not isinstance(descriptions, list):
            return Response({"error": "Description must be a list"}, status=status.HTTP_400_BAD_REQUEST)
        
        if not descriptions:
            return Response({"error": "Description can't be null"}, status=status.HTTP_400_BAD_REQUEST)
        
        for description in descriptions:
            if not isinstance(description, str):
                return Response({"error": "Each description must be a string"}, status=status.HTTP_400_BAD_REQUEST)
        
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

# Course Outline Views
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

# Course Schedule Views
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

# Course Assessment Views
class CourseAssessmentCreateView(generics.CreateAPIView):
    queryset = CourseAssessment.objects.all()
    serializer_class = CourseAssessmentSerializer
    permission_classes = [IsSuper_University_Campus_Department]
    authentication_classes = [JWTStatelessUserAuthentication]

    def create(self, request):
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

# Course Books Views
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

# Weekly Topic Views
class WeeklyTopicCreateView(generics.CreateAPIView):
    queryset = WeeklyTopic.objects.all()
    serializer_class = WeeklyTopicSerializer
    permission_classes = [IsSuper_University_Campus_Department]
    authentication_classes = [JWTStatelessUserAuthentication]

    def create(self, request, *args, **kwargs):
        if request.data.get('generate', False):
            course_id = request.data.get('course_id')
            teacher_id = request.data.get('teacher_id')
            batch_id = request.data.get('batch_id')
            user_comments = request.data.get('comments', '')

            try:
                weekly_topics_objects = generate_weekly_topics(course_id, teacher_id, batch_id, user_comments)
                serialized_data = WeeklyTopicSerializer(weekly_topics_objects, many=True)
                return Response(serialized_data.data, status=status.HTTP_201_CREATED)
            except ValueError as e:
                return Response({"detail": str(e)}, status=status.HTTP_400_BAD_REQUEST)
            except Exception as e:
                return Response({"detail": "An unexpected error occurred."+str(e)}, status=status.HTTP_500_INTERNAL_SERVER_ERROR)

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

# Complete Outline View
class CompleteOutlineView(APIView):
    permission_classes = [IsSuper_University_Campus_Department]
    authentication_classes = [JWTStatelessUserAuthentication]
    def get(self, request, pk):
        outline = get_object_or_404(CourseOutline, id=pk)
        serialized_data = CompleteOutlineSerializer(outline)
        return Response(serialized_data.data, status=status.HTTP_200_OK)


# CLO View
class CLODataView(APIView):
    def post(self, request):
        clo_description = request.data['clo_description']
        domain, level, level_number, related_plos = determine_clo_details(clo_description)

        data = {
            'description': clo_description,
            'bloom_taxonomy': domain,
            'level': level_number,
            'plos': related_plos
        }

        return Response(data)



class GenerateCLOsView(generics.GenericAPIView):
    permission_classes = [IsSuper_University_Campus_Department]
    authentication_classes = [JWTStatelessUserAuthentication]

    def post(self, request, *args, **kwargs):
        # Check if request is to generate CLOs
        course_outline_id = request.data.get('course_outline_id')
        user_comments = request.data.get('user_comments', '')

        if not course_outline_id:
            return Response({"error": "Course outline ID is required to generate CLOs."}, status=status.HTTP_400_BAD_REQUEST)
        
        try:
            clos_data = generate_clos_from_weekly_topics(course_outline_id, user_comments)
            return Response(clos_data, status=status.HTTP_200_OK)
        except ValueError as e:
            return Response({"error": str(e)}, status=status.HTTP_400_BAD_REQUEST)
