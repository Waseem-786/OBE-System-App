from rest_framework import serializers
from django.contrib.auth.models import Group, User
from djoser.serializers import UserCreateSerializer

class RoleSerializer(serializers.ModelSerializer):
    class Meta:
        model = Group
        fields = '__all__'

class UserSerializer(serializers.ModelSerializer):
    class Meta:
        model = User
        fields = ['id','username','email','first_name','last_name']


class CustomUserCreateSerializer(UserCreateSerializer):
    class Meta(UserCreateSerializer.Meta):
        fields = ('username', 'email', 'password', 'first_name', 'last_name')

    def validate(self, data):
        if 'email' not in data or 'first_name' not in data or 'last_name' not in data:
            raise serializers.ValidationError("Email, first name, and last name are required.")
        return data