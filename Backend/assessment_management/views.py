from django.shortcuts import get_object_or_404
from rest_framework import generics, status
from rest_framework.views import APIView, Response
from rest_framework_simplejwt.authentication import JWTStatelessUserAuthentication
from .models import Assessment, Question, QuestionPart
from .serializers import AssessmentSerializer, QuestionSerializer, QuestionPartSerializer
from user_management.permissions import IsDepartmentAdmin


class AssessmentView(generics.ListCreateAPIView):
    queryset = Assessment.objects.all()
    serializer_class = AssessmentSerializer
    permission_classes = [IsDepartmentAdmin]
    authentication_classes = [JWTStatelessUserAuthentication]

class SingleAssessmentView(generics.RetrieveUpdateDestroyAPIView):
    queryset = Assessment.objects.all()
    serializer_class = AssessmentSerializer
    permission_classes = [IsDepartmentAdmin]
    authentication_classes = [JWTStatelessUserAuthentication]


class QuestionView(generics.ListCreateAPIView):
    queryset = Question.objects.all()
    serializer_class = QuestionSerializer
    permission_classes = [IsDepartmentAdmin]
    authentication_classes = [JWTStatelessUserAuthentication]

class SingleQuestionView(generics.RetrieveUpdateDestroyAPIView):
    queryset = Question.objects.all()
    serializer_class = QuestionSerializer
    permission_classes = [IsDepartmentAdmin]
    authentication_classes = [JWTStatelessUserAuthentication]

class QuestionPartView(generics.ListCreateAPIView):
    queryset = QuestionPart.objects.all()
    serializer_class = QuestionPartSerializer
    permission_classes = [IsDepartmentAdmin]
    authentication_classes = [JWTStatelessUserAuthentication]

class SingleQuestionPartView(generics.RetrieveUpdateDestroyAPIView):
    queryset = QuestionPart.objects.all()
    serializer_class = QuestionPartSerializer
    permission_classes = [IsDepartmentAdmin]
    authentication_classes = [JWTStatelessUserAuthentication]

class AssessmentQuestionPartCreateView(APIView):
    authentication_classes = [JWTStatelessUserAuthentication]
    permission_classes = [IsDepartmentAdmin]

    def post(self, request):
        assessment_data = request.data.get('assessment')
        questions_data = request.data.get('questions', [])
        parts_data = request.data.get('parts', [])

        # Serialize assessment data
        assessment_serializer = AssessmentSerializer(data=assessment_data)
        if not assessment_serializer.is_valid():
            return Response({"error": assessment_serializer.errors}, status=status.HTTP_400_BAD_REQUEST)

        # Save assessment
        assessment_instance = assessment_serializer.save()

        # Serialize and save questions
        for question_data in questions_data:
            question_data['assessment'] = assessment_instance.pk  # Add assessment ID to each question data
            question_serializer = QuestionSerializer(data=question_data)
            if question_serializer.is_valid():
                question_serializer.save()

        # Serialize and save question parts
        for part_data in parts_data:
            part_data['question'] = assessment_instance.questions.first().pk  # Add question ID to each part data
            part_serializer = QuestionPartSerializer(data=part_data)
            if part_serializer.is_valid():
                part_serializer.save()

        return Response({"message": "Assessment, questions, and question parts created successfully"}, status=status.HTTP_201_CREATED)
