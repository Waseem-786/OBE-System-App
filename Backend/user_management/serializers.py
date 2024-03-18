from rest_framework import serializers
from django.contrib.auth.models import Group
from .models import CustomUser

class RoleSerializer(serializers.ModelSerializer):
    class Meta:
        model = Group
        fields = '__all__'

class UserSerializer(serializers.ModelSerializer):
    class Meta:
        model = CustomUser
        fields = ['id','username','email','first_name','last_name','university']