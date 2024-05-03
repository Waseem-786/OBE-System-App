from rest_framework import serializers
from .models import ChainOfCommand, ChainOfCommandUser
from user_management.models import CustomUser

class ChainOfCommandUserSerializer(serializers.ModelSerializer):
    user_id = serializers.PrimaryKeyRelatedField(queryset=CustomUser.objects.all(), source='user')
    class Meta:
        model = ChainOfCommandUser
        fields = ['user_id', 'order']

class ChainOfCommand_Serializer(serializers.ModelSerializer):
    users = ChainOfCommandUserSerializer(source='chainofcommanduser_set', many=True, read_only=True)

    class Meta:
        model = ChainOfCommand
        fields = '__all__'
