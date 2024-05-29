from django.shortcuts import get_object_or_404
from rest_framework import generics, status
from rest_framework.views import APIView, Response
from rest_framework_simplejwt.authentication import JWTStatelessUserAuthentication
from .models import Assessment, Question, QuestionPart
from .serializers import AssessmentSerializer, QuestionSerializer, QuestionPartSerializer, CompleteAssessmentSerializer
from user_management.permissions import IsSuper_University_Campus_Department
from django.db import transaction


class AssessmentView(generics.ListCreateAPIView):
    queryset = Assessment.objects.all()
    serializer_class = AssessmentSerializer
    permission_classes = [IsSuper_University_Campus_Department]
    authentication_classes = [JWTStatelessUserAuthentication]

class SingleAssessmentView(generics.RetrieveUpdateDestroyAPIView):
    queryset = Assessment.objects.all()
    serializer_class = AssessmentSerializer
    permission_classes = [IsSuper_University_Campus_Department]
    authentication_classes = [JWTStatelessUserAuthentication]


class QuestionView(generics.ListCreateAPIView):
    queryset = Question.objects.all()
    serializer_class = QuestionSerializer
    permission_classes = [IsSuper_University_Campus_Department]
    authentication_classes = [JWTStatelessUserAuthentication]

class SingleQuestionView(generics.RetrieveUpdateDestroyAPIView):
    queryset = Question.objects.all()
    serializer_class = QuestionSerializer
    permission_classes = [IsSuper_University_Campus_Department]
    authentication_classes = [JWTStatelessUserAuthentication]

class QuestionPartView(generics.ListCreateAPIView):
    queryset = QuestionPart.objects.all()
    serializer_class = QuestionPartSerializer
    permission_classes = [IsSuper_University_Campus_Department]
    authentication_classes = [JWTStatelessUserAuthentication]

class SingleQuestionPartView(generics.RetrieveUpdateDestroyAPIView):
    queryset = QuestionPart.objects.all()
    serializer_class = QuestionPartSerializer
    permission_classes = [IsSuper_University_Campus_Department]
    authentication_classes = [JWTStatelessUserAuthentication]



class CompleteQuestionView(generics.CreateAPIView):
    serializer_class = QuestionSerializer
    permission_classes = [IsSuper_University_Campus_Department]
    authentication_classes = [JWTStatelessUserAuthentication]

    def create(self, request, *args, **kwargs):
        serializer = self.get_serializer(data=request.data)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data, status=status.HTTP_201_CREATED)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)



class CompleteAssessmentCreateView(generics.ListCreateAPIView):
    queryset = Assessment.objects.all()
    serializer_class = CompleteAssessmentSerializer
    permission_classes = [IsSuper_University_Campus_Department]
    authentication_classes = [JWTStatelessUserAuthentication]

    def create(self, request, *args, **kwargs):
        serializer = self.get_serializer(data=request.data)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data, status=status.HTTP_201_CREATED)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

class CompleteAssessmentView(generics.ListAPIView):
    queryset = Assessment.objects.all()
    serializer_class = CompleteAssessmentSerializer
    permission_classes = [IsSuper_University_Campus_Department]
    authentication_classes = [JWTStatelessUserAuthentication]
    lookup_field = 'id'
    lookup_url_kwarg = 'assessment_id'

    def get(self, request, *args, **kwargs):
        try:
            assessment = self.get_object()
        except Assessment.DoesNotExist:
            return Response('Assessment not found')
        
        serializer = self.get_serializer(assessment)
        return Response(serializer.data)