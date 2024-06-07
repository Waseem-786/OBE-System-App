from rest_framework import serializers
from .models import Assessment, Question, QuestionPart, CourseLearningOutcomes

class QuestionPartSerializer(serializers.ModelSerializer):
    class Meta:
        model = QuestionPart
        fields = ['id', 'description', 'marks']

class QuestionSerializer(serializers.ModelSerializer):
    parts = QuestionPartSerializer(many=True)
    clo = serializers.PrimaryKeyRelatedField(queryset=CourseLearningOutcomes.objects.all(), many=True)

    class Meta:
        model = Question
        fields = ['id', 'description', 'clo', 'parts']

    def create(self, validated_data):
        parts_data = validated_data.pop('parts')
        clo_data = validated_data.pop('clo')
        question = Question.objects.create(**validated_data)
        question.clo.set(clo_data)
        for part_data in parts_data:
            QuestionPart.objects.create(question=question, **part_data)
        return question

class AssessmentSerializer(serializers.ModelSerializer):
    questions = QuestionSerializer(many=True)

    class Meta:
        model = Assessment
        fields = ['id', 'name', 'teacher', 'batch', 'course', 'total_marks', 'duration', 'instruction', 'questions']

    def create(self, validated_data):
        questions_data = validated_data.pop('questions')
        assessment = Assessment.objects.create(**validated_data)
        for question_data in questions_data:
            parts_data = question_data.pop('parts')
            clo_data = question_data.pop('clo')
            question = Question.objects.create(assessment=assessment, **question_data)
            question.clo.set(clo_data)
            for part_data in parts_data:
                QuestionPart.objects.create(question=question, **part_data)
        return assessment
