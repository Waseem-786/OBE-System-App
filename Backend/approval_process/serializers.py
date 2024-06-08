from rest_framework import serializers
from .models import ApprovalStep, ApprovalProcess, ApprovalLog

class ApprovalStepSerializer(serializers.ModelSerializer):
    class Meta:
        model = ApprovalStep
        fields = '__all__'

class ApprovalLogSerializer(serializers.ModelSerializer):
    user = serializers.StringRelatedField()
    step = serializers.StringRelatedField()

    class Meta:
        model = ApprovalLog
        fields = '__all__'

class ApprovalProcessSerializer(serializers.ModelSerializer):
    logs = ApprovalLogSerializer(many=True, read_only=True)
    current_step = serializers.StringRelatedField()

    class Meta:
        model = ApprovalProcess
        fields = '__all__'
