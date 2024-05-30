from rest_framework import serializers, status
from rest_framework.response import Response
from rest_framework import generics
from .models import Assessment, Question, QuestionPart
from user_management.models import CustomUser
from university_management.models import Batch
from course_management.models import CourseInformation, CourseLearningOutcomes

class AssessmentSerializer(serializers.ModelSerializer):
    class Meta:
        model = Assessment
        fields = '__all__'

class QuestionPartSerializer(serializers.ModelSerializer):
    class Meta:
        model = QuestionPart
        fields = ['description', 'marks']

class QuestionSerializer(serializers.ModelSerializer):
    parts = QuestionPartSerializer(many=True)

    class Meta:
        model = Question
        fields = ['description', 'parts', 'clo']

    def create(self, validated_data):
        parts_data = validated_data.pop('parts')
        clo_ids = validated_data.pop('clo')
        question = Question.objects.create(**validated_data)
        question.clo.set(clo_ids)
        for part_data in parts_data:
            QuestionPart.objects.create(question=question, **part_data)
        return question

class CompleteAssessmentSerializer(serializers.ModelSerializer):
    questions = QuestionSerializer(many=True)

    class Meta:
        model = Assessment
        fields = ['id', 'name', 'teacher', 'batch', 'course', 'total_marks', 'duration', 'instruction', 'questions']

    def create(self, validated_data):
        questions_data = validated_data.pop('questions')
        assessment = Assessment.objects.create(**validated_data)
        for question_data in questions_data:
            question_parts_data = question_data.pop('parts')
            clo_ids = question_data.pop('clo')
            question_data['assessment'] = assessment
            question = Question.objects.create(**question_data)
            question.clo.set(clo_ids)
            for part_data in question_parts_data:
                QuestionPart.objects.create(question=question, **part_data)
        return assessment