from rest_framework import serializers
from .models import CourseInformation, CourseSchedule, CourseObjective, CourseAssessment, CourseBooks, CourseLearningOutcomes, CourseOutline, WeeklyTopic
from program_management.models import PLO

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
    plo = serializers.PrimaryKeyRelatedField(queryset=PLO.objects.all(), many=True)

    class Meta:
        model = CourseLearningOutcomes
        fields = '__all__'

    def validate_plo(self, value):
        if not value:
            raise serializers.ValidationError("At least one PLO must be provided.")
        return value


class CourseOutlineSerializer(serializers.ModelSerializer):
    course_name = serializers.CharField(source='course.title',read_only=True)
    batch_name = serializers.CharField(source='batch.name',read_only=True)
    teacher_name = serializers.CharField(source='teacher.first_name',read_only=True)
    class Meta:
        model = CourseOutline
        fields = ['id','course', 'course_name', 'batch', 'batch_name','teacher','teacher_name']


class WeeklyTopicSerializer(serializers.ModelSerializer):
    class Meta:
        model = WeeklyTopic
        fields = '__all__'

class ObjectivesSerializer(serializers.ModelSerializer):
    class Meta:
        model = CourseObjective
        fields = ['id', 'description']

class CLOsSerializer(serializers.ModelSerializer):
    class Meta:
        model = CourseLearningOutcomes
        fields = '__all__'

class CompleteOutlineSerializer(serializers.ModelSerializer):
    batch_name = serializers.CharField(source='batch.name', read_only=True)
    university_name = serializers.CharField(source='batch.department.campus.university.name', read_only=True)
    department_name = serializers.CharField(source='batch.department.name', read_only=True)
    campus_name = serializers.CharField(source='batch.department.campus.name', read_only=True)
    teacher_first_name = serializers.CharField(source='teacher.first_name', read_only=True)
    teacher_last_name = serializers.CharField(source='teacher.last_name', read_only=True)

    course_info = CourseInformationSerializer(source='course', read_only=True)
    objectives = ObjectivesSerializer(source='course.courseobjective_set', many=True, read_only=True)
    clos = CLOsSerializer(source='course.courselearningoutcomes_set', many=True, read_only=True)
    schedule = CourseScheduleSerializer(source='courseschedule', read_only=True)
    assessments = CourseAssessmentSerializer(source='courseassessment_set', many=True, read_only=True)
    weekly_topics = WeeklyTopicSerializer(source='weeklytopic_set', many=True, read_only=True)
    books = CourseBookSerializer(source='coursebooks_set', many=True, read_only=True)

    class Meta:
        model = CourseOutline
        fields = ['id', 'batch', 'batch_name', 'university_name', 'campus_name', 'department_name', 'teacher', 'teacher_first_name', 'teacher_last_name', 'course_info', 'objectives', 'clos', 'schedule', 'assessments', 'weekly_topics', 'books']
