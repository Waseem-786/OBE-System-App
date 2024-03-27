from rest_framework import serializers
from .models import University, Campus, Department, Section, Batch

class UniversitySerializer(serializers.ModelSerializer):
    class Meta:
        model = University
        fields = ['name','vision','mission']

class CampusSerializer(serializers.ModelSerializer):
    class Meta:
        model = Campus
        fields = ['name','vision','mission','university']
