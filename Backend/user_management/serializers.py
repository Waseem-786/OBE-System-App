from rest_framework import serializers
from .models import CustomUser, CustomGroup
from djoser.serializers import UserCreateSerializer
from django.contrib.auth.models import Permission

class RoleSerializer(serializers.ModelSerializer):
    university_name = serializers.CharField(source='university.name', read_only=True)
    campus_name = serializers.CharField(source='campus.name', read_only=True)
    department_name = serializers.CharField(source='department.name', read_only=True)
    group_name = serializers.CharField(source='group.name', read_only=True)
    group_permissions = serializers.SerializerMethodField()
    user_names = serializers.SerializerMethodField()

    class Meta:
        model = CustomGroup
        fields = ['id', 'group', 'group_name', 'group_permissions', 'user', 'user_names', 'university', 'university_name', 'campus', 'campus_name', 'department', 'department_name']

    def get_group_permissions(self, obj):
        return obj.group.permissions.values_list('name', flat=True)

    def get_user_names(self, obj):
        # Fetching all user names associated with the custom group
        return [user.username for user in obj.user.all()]

class UserSerializer(serializers.ModelSerializer):
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
        fields = '__all__'


class CustomUserCreateSerializer(UserCreateSerializer):
    class Meta(UserCreateSerializer.Meta):
        model = CustomUser
        UserCreateSerializer.Meta.fields = tuple(UserCreateSerializer.Meta.fields) + ('first_name','last_name','university','campus','department')


class PermissionsSerializer(serializers.ModelSerializer):
    class Meta:
        model = Permission
        fields = '__all__'

class GroupSerializer(serializers.ModelSerializer):
    group_name = serializers.CharField(source='group.name', read_only=True)
    class Meta:
        model = CustomGroup
        fields = ['id', 'group', 'group_name']