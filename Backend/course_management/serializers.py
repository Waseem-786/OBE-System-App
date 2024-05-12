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
    
class CourseObjectiveListSerializer(serializers.ModelSerializer):
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
    course_name = serializers.CharField(source='course.title',read_only=True)
    batch_name = serializers.CharField(source='batch.name',read_only=True)
    teacher_name = serializers.CharField(source='teacher.first_name',read_only=True)
    class Meta:
        model = CourseOutline
        fields = ['id','course', 'course_name', 'batch', 'batch_name','teacher','teacher_name']

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

    

class ObjectivesSerializer(serializers.ModelSerializer):
    objectives = serializers.SerializerMethodField()
    class Meta:
        model = CourseInformation
        fields = ['objectives']
    def get_objectives(self, obj):
        objectives = obj.courseobjective_set.all()
        return CourseObjectiveListSerializer(objectives, many=True).data


class CLOsSerializer(serializers.ModelSerializer):
    clo = serializers.SerializerMethodField()
    class Meta:
        model = CourseInformation
        fields = ['clo']
    def get_clo(self, obj):
        clo = obj.courselearningoutcomes_set.all()
        return CourseLearningOutcomesSerializer(clo, many=True).data

class CompleteOutlineSerializer(serializers.ModelSerializer):
    batch_name = serializers.CharField(source='batch.name', read_only=True)
    teacher_first_name = serializers.CharField(source='teacher.first_name', read_only=True)
    teacher_last_name = serializers.CharField(source='teacher.last_name', read_only=True)

    course_info = CourseInformationSerializer(source='course', read_only=True)
    objectives = ObjectivesSerializer(source='course', read_only=True)
    clos = CLOsSerializer(source='course', read_only=True)
    schedule = CourseScheduleSerializer(source='courseschedule', read_only=True)
    assessments = CourseAssessmentSerializer(source='courseassessment_set', many=True, read_only=True)
    weekly_topics = WeeklyTopicSerializer(source='weeklytopic_set', many=True, read_only=True)
    books = CourseBookSerializer(source='coursebooks_set', many=True, read_only=True)

    class Meta:
        model = CourseOutline
        fields = ['id','batch','batch_name','teacher','teacher_first_name','teacher_last_name', 'course_info','objectives', 'clos' ,'schedule', 'assessments', 'weekly_topics', 'books']
