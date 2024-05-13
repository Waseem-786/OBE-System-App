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
    sections = serializers.ListSerializer(child=serializers.CharField())

    class Meta:
        model = Batch
        fields = ['id', 'name', 'department', 'sections']

    def get_section_names(self, obj):
        return [section.name for section in obj.sections.all()]

    def create(self, validated_data):
        sections_data = validated_data.pop('sections')
        batch = Batch.objects.create(**validated_data)
        for section_name in sections_data:
            section, _ = Section.objects.get_or_create(name=section_name)
            batch.sections.add(section)
        return batch

    def update(self, instance, validated_data):
        sections_data = validated_data.pop('sections', [])
        instance = super().update(instance, validated_data)

        existing_sections = instance.sections.all()
        existing_section_names = set(section.name for section in existing_sections)

        

        # If that section is not already present then add
        for section_name in sections_data:
            if section_name not in existing_section_names:
                section, _ = Section.objects.get_or_create(name=section_name)

        # Delete sections not included in the update
        for section_name in existing_section_names:
            section = Section.objects.get(name=section_name)
            instance.sections.remove(section)

        return instance