from rest_framework import serializers
from .models import CourseInformation, CourseSchedule, CourseObjective, CourseAssessment, CourseBooks, CourseLearningOutcomes, CourseOutline, WeeklyTopic, PLO_CLO_Mapping

class CourseInformationSerializer(serializers.ModelSerializer):
    class Meta:
        model = CourseInformation
        fields = '__all__'

class CourseScheduleSerializer(serializers.ModelSerializer):
    class Meta:
        model = CourseSchedule
        fields = '__all__'

class CourseObjectiveSerializer(serializers.ModelSerializer):
    description = serializers.ListField(
        child=serializers.CharField(allow_blank=False, max_length=100)
    )
    class Meta:
        model = CourseObjective
        fields = '__all__'

class CourseAssessmentSerializer(serializers.ModelSerializer):
    class Meta:
        model = CourseAssessment
        fields = '__all__'

class CourseBookSerializer(serializers.ModelSerializer):
    class Meta:
        model = CourseBooks
        fields = '__all__'

class CourseLearningOutcomesSerializer(serializers.ModelSerializer):
    class Meta:
        model = CourseLearningOutcomes
        fields = '__all__'


class CourseOutlineSerializer(serializers.ModelSerializer):
    class Meta:
        model = CourseOutline
        fields = '__all__'

class PLO_CLO_Mapping_Serializer(serializers.ModelSerializer):
    plo_name = serializers.CharField(source='plo.name',read_only=True)
    clo_description = serializers.CharField(source='clo.description',read_only=True)
    class Meta:
        model = PLO_CLO_Mapping
        fields = ['id','plo','plo_name','clo','clo_description']


class WeeklyTopicSerializer(serializers.ModelSerializer):
    class Meta:
        model = WeeklyTopic
        fields = '__all__'