from rest_framework import serializers
from .models import University, Campus, Department, Section, Batch

class UniversitySerializer(serializers.ModelSerializer):
    class Meta:
        model = University
        fields = ['name','vision','mission']

class CampusSerializer(serializers.ModelSerializer):
    university_name = serializers.CharField(source='university.name', read_only=True)
    class Meta:
        model = Campus
        fields = ['name','vision','mission','university', 'university_name']


class DepartmentSerializer(serializers.ModelSerializer):
    university_name = serializers.CharField(source='university.name', read_only=True)
    campus_name = serializers.CharField(source='campus.name', read_only=True)
    class Meta:
        model = Department
        fields = ['name','vision','mission','university_name','campus','campus_name']


class BatchSerializer(serializers.ModelSerializer):
    class Meta:
        model = Batch
        fields = '__all__'


class SectionSerializer(serializers.ModelSerializer):
    class Meta:
        model = Section
        fields = '__all__'