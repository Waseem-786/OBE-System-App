from rest_framework import serializers
from .models import ApprovalChain, ApprovalEntity, Approval

class ApprovalEntitySerializer(serializers.ModelSerializer):
    class Meta:
        model = ApprovalEntity
        fields = '__all__'

class ApprovalChainSerializer(serializers.ModelSerializer):
    class Meta:
        model = ApprovalChain
        fields = '__all__'

class ApprovalSerializer(serializers.ModelSerializer):
    class Meta:
        model = Approval
        fields = '__all__'
