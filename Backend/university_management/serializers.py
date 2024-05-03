from rest_framework import serializers
from .models import University, Campus, Department, Section, Batch, BatchSection

class UniversitySerializer(serializers.ModelSerializer):
    class Meta:
        model = University
        fields = ['id','name','vision','mission']

class CampusSerializer(serializers.ModelSerializer):
    university_name = serializers.CharField(source='university.name', read_only=True)
    class Meta:
        model = Campus
        fields = ['id','name','vision','mission','university', 'university_name']


class DepartmentSerializer(serializers.ModelSerializer):
    campus_name = serializers.CharField(source='campus.name', read_only=True)
    class Meta:
        model = Department
        fields = ['id','name','vision','mission','campus','campus_name']


class BatchSerializer(serializers.ModelSerializer):
    class Meta:
        model = Batch
        fields = '__all__'


class SectionSerializer(serializers.ModelSerializer):
    class Meta:
        model = Section
        fields = '__all__'
    
class BatchSectionSerializer(serializers.ModelSerializer):
    class Meta:
        model = BatchSection
        fields = '__all__'

# class BatchSectionSerializer(serializers.ModelSerializer):
#     batch_name = serializers.CharField(source='batch.name', read_only=True)
#     department_name = serializers.CharField(source='batch.department.name', read_only=True)
#     section_name = serializers.CharField(source='section.name', read_only=True)
#     class Meta:
#         model = BatchSection
#         fields = ['id', 'batch', 'batch_name','department_name', 'section', 'section_name']