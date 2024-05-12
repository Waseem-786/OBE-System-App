from rest_framework import serializers
from .models import University, Campus, Department, Section, Batch

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


class SectionSerializer(serializers.ModelSerializer):
    class Meta:
        model = Section
        fields = '__all__'

class BatchSerializer(serializers.ModelSerializer):
    sections = serializers.ListSerializer(child=serializers.CharField(), write_only=True)
    section_names = serializers.SerializerMethodField()

    class Meta:
        model = Batch
        fields = ['id', 'name', 'department', 'sections', 'section_names']

    def get_section_names(self, obj):
        return [section.name for section in obj.sections.all()]
    
    def create(self, validated_data):
        sections_data = validated_data.pop('sections')
        batch = Batch.objects.create(**validated_data)
        for section_name in sections_data:
            section, _ = Section.objects.get_or_create(name=section_name)
            batch.sections.add(section)
        return batch
    