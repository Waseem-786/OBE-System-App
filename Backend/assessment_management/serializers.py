from rest_framework import serializers
from .models import Assessment, Question, QuestionPart

class AssessmentSerializer(serializers.ModelSerializer):
    batch_name = serializers.CharField(source='batch.name', read_only=True)
    course_name = serializers.CharField(source='course.title', read_only=True)
    teacher_first_name = serializers.CharField(source='teacher.first_name', read_only=True)
    teacher_last_name = serializers.CharField(source='teacher.last_name', read_only=True)
    class Meta:
        model = Assessment
        fields =  ['id','name','teacher','teacher_first_name','teacher_last_name','batch','batch_name','course','course_name','total_marks']


class QuestionSerializer(serializers.ModelSerializer):
    class Meta:
        model = Question
        fields = '__all__'
        depth=1

class QuestionPartSerializer(serializers.ModelSerializer):
    class Meta:
        model = QuestionPart
        fields = '__all__'