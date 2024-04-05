from rest_framework import serializers
from .models import CustomUser, CustomGroup
from djoser.serializers import UserCreateSerializer

class TopLevelRoleSerializer(serializers.ModelSerializer):
    group_name = serializers.CharField(source='group.name', read_only=True)
    class Meta:
        model = CustomGroup
        fields = ['id','group_name']

class UniversityLevelRoleSerializer(serializers.ModelSerializer):
    university_name = serializers.CharField(source='university.name', read_only=True)
    group_name = serializers.CharField(source='group.name', read_only=True)
    class Meta:
        model = CustomGroup
        fields = ['id','group_name','university','university_name']


class CampusLevelRoleSerializer(serializers.ModelSerializer):
    university_name = serializers.CharField(source='university.name', read_only=True)
    campus_name = serializers.CharField(source='campus.name', read_only=True)
    group_name = serializers.CharField(source='group.name', read_only=True)
    class Meta:
        model = CustomGroup
        fields = ['id','group_name','university','university_name','campus','campus_name']

class DepartmentLevelRoleSerializer(serializers.ModelSerializer):
    university_name = serializers.CharField(source='university.name', read_only=True)
    campus_name = serializers.CharField(source='campus.name', read_only=True)
    department_name = serializers.CharField(source='department.name', read_only=True)
    group_name = serializers.CharField(source='group.name', read_only=True)
    class Meta:
        model = CustomGroup
        fields = ['id','group_name','university','university_name','campus','campus_name','department','department_name']


class RoleSerializer(serializers.ModelSerializer):
    class Meta:
        model = CustomGroup
        fields = '__all__'

class UniversityAdminUserSerializer(serializers.ModelSerializer):
    university_name = serializers.CharField(source='university.name', read_only=True)

    class Meta:
        model = CustomUser
        fields = ['id', 'username', 'email', 'first_name','last_name', 'university', 'university_name']

class CampusAdminUserSerializer(serializers.ModelSerializer):
    university_name = serializers.CharField(source='university.name', read_only=True)
    campus_name = serializers.CharField(source='campus.name', read_only=True)

    class Meta:
        model = CustomUser
        fields = ['id', 'username', 'email', 'first_name','last_name', 'university', 'university_name','campus','campus_name']

class DepartmentAdminUserSerializer(serializers.ModelSerializer):
    university_name = serializers.CharField(source='university.name', read_only=True)
    campus_name = serializers.CharField(source='campus.name', read_only=True)
    department_name = serializers.CharField(source='department.name', read_only=True)

    class Meta:
        model = CustomUser
        fields = ['id', 'username', 'email', 'first_name','last_name', 'university', 'university_name','campus','campus_name', 'department', 'department_name']


class CustomUserSerializer(serializers.ModelSerializer):
    university_name = serializers.CharField(source='university.name', read_only=True)
    campus_name = serializers.CharField(source='campus.name', read_only=True)
    department_name = serializers.CharField(source='department.name', read_only=True)

    class Meta:
        model = CustomUser
        fields = ['id', 'username', 'email', 'first_name','last_name', 'university_name', 'campus_name', 'department_name']


class CustomUserCreateSerializer(UserCreateSerializer):
    class Meta(UserCreateSerializer.Meta):
        model = CustomUser
        UserCreateSerializer.Meta.fields = tuple(UserCreateSerializer.Meta.fields) + ('first_name','last_name','university','campus','department')