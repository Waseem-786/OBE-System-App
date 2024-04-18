from django.shortcuts import get_object_or_404
from rest_framework import generics
from rest_framework_simplejwt.authentication import JWTStatelessUserAuthentication
from user_management.permissions import IsSuperUser, IsUniversityAdmin, IsCampusAdmin, IsDepartmentAdmin, IsSuper_University, IsSuper_University_Campus, IsSuper_University_Campus_Department

from .models import CourseInformation, CourseSchedule, CourseObjective, CourseAssessment, Grading, Book, Reference, Text, CourseLearningOutcomes, CourseOutline
from .serializers import CourseInformationSerializer, CourseScheduleSerializer, CourseObjectiveSerializer, CourseAssessmentSerializer, GradingSerializer, BookSerializer, ReferenceSerializer, TextSerializer, CourseLearningOutcomesSerializer, CourseOutlineSerializer
# Create your views here.
class CourseInformationView(generics.ListCreateAPIView):
    queryset = CourseInformation.objects.all()
    serializer_class = CourseInformationSerializer
    permission_classes = [IsUniversityAdmin]
    authentication_classes = [JWTStatelessUserAuthentication]
