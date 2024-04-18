from rest_framework import serializers
from .models import PEO, PLO, PEO_PLO_Mapping

class PEO_Serializer(serializers.ModelSerializer):
    class Meta:
        model = PEO
        fields = '__all__'

class PLO_Serializer(serializers.ModelSerializer):
    class Meta:
        model = PLO
        fields = '__all__'

class PEO_PLO_Mapping_Serializer(serializers.ModelSerializer):
    program = serializers.CharField(source='peo.program', read_only=True)
    peo_description = serializers.CharField(source='peo.description', read_only=True)
    plo_description = serializers.CharField(source='plo.description', read_only=True)
    class Meta:
        model = PEO_PLO_Mapping
        fields = ['id','program','peo','peo_description','plo','plo_description']