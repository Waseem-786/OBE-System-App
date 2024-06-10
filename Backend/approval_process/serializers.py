from rest_framework import serializers
from .models import ApprovalChain, CLOUpdateRequest, ApprovalProcess, ApprovalChainStep, ApprovalStep

class ApprovalStepSerializer(serializers.ModelSerializer):
    class Meta:
        model = ApprovalStep
        fields = '__all__'

class ApprovalChainStepSerializer(serializers.ModelSerializer):
    class Meta:
        model = ApprovalChainStep
        fields = '__all__'

class ApprovalChainSerializer(serializers.ModelSerializer):
    steps = ApprovalChainStepSerializer(many=True, read_only=True)

    class Meta:
        model = ApprovalChain
        fields = '__all__'

class CLOUpdateRequestSerializer(serializers.ModelSerializer):
    class Meta:
        model = CLOUpdateRequest
        fields = '__all__'

class ApprovalProcessSerializer(serializers.ModelSerializer):
    class Meta:
        model = ApprovalProcess
        fields = '__all__'
