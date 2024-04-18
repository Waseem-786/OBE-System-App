from rest_framework import serializers
from .models import CourseInformation, CourseSchedule, CourseObjective, CourseAssessment, Grading, Book, Reference, Text, CourseLearningOutcomes, CourseOutline

class CourseInformationSerializer(serializers.ModelSerializer):
    class Meta:
        model = CourseInformation
        fields = '__all__'

class CourseScheduleSerializer(serializers.ModelSerializer):
    class Meta:
        model = CourseSchedule
        fields = '__all__'

class CourseObjectiveSerializer(serializers.ModelSerializer):
    class Meta:
        model = CourseObjective
        fields = '__all__'

class CourseAssessmentSerializer(serializers.ModelSerializer):
    class Meta:
        model = CourseAssessment
        fields = '__all__'

class GradingSerializer(serializers.ModelSerializer):
    class Meta:
        model = Grading
        fields = '__all__'

class BookSerializer(serializers.ModelSerializer):
    class Meta:
        model = Book
        fields = '__all__'

class ReferenceSerializer(serializers.ModelSerializer):
    class Meta:
        model = Reference
        fields = '__all__'

class TextSerializer(serializers.ModelSerializer):
    class Meta:
        model = Text
        fields = '__all__'

class CourseLearningOutcomesSerializer(serializers.ModelSerializer):
    class Meta:
        model = CourseLearningOutcomes
        fields = '__all__'


class CourseOutlineSerializer(serializers.ModelSerializer):
    class Meta:
        model = CourseOutline
        fields = '__all__'

