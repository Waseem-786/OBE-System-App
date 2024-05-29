from rest_framework import serializers
from .models import CustomUser, CustomGroup
from djoser.serializers import UserCreateSerializer
from django.contrib.auth.models import Permission, Group

class RoleSerializer(serializers.ModelSerializer):
    university_name = serializers.CharField(source='university.name', read_only=True)
    campus_name = serializers.CharField(source='campus.name', read_only=True)
    department_name = serializers.CharField(source='department.name', read_only=True)
    group_name = serializers.CharField(source='group.name', read_only=True)
    name = serializers.CharField(write_only=True, required=True)  # Field for the group name
    group_permissions = serializers.SerializerMethodField()
    user_names = serializers.SerializerMethodField()

    permissions = serializers.ListField(
        child=serializers.IntegerField(), write_only=True, required=True
    )
    users = serializers.ListField(
        child=serializers.IntegerField(), write_only=True, required=True  # Changed to IntegerField
    )

    class Meta:
        model = CustomGroup
        fields = [
            'id', 'group_name', 'name', 'group_permissions', 'user', 'user_names',
            'university', 'university_name', 'campus', 'campus_name', 'department', 'department_name',
            'permissions', 'users'
        ]

    def get_group_permissions(self, obj):
        return obj.group.permissions.values_list('name', flat=True)

    def get_user_names(self, obj):
        return [user.username for user in obj.user.all()]

    def validate(self, data):
        if not data.get('permissions'):
            raise serializers.ValidationError({'permissions': 'This field is required and must have at least one permission.'})
        if not data.get('users'):
            raise serializers.ValidationError({'users': 'This field is required and must have at least one user.'})
        if not data.get('name'):
            raise serializers.ValidationError({'name': 'This field is required for the group name.'})
        return data

    def create(self, validated_data):
        permissions = validated_data.pop('permissions')
        users = validated_data.pop('users')
        group_name = validated_data.pop('name')

        group, _ = Group.objects.get_or_create(name=group_name)
        custom_group_data = {
            "group": group,
            "university": validated_data.get("university", None),
            "campus": validated_data.get("campus", None),
            "department": validated_data.get("department", None)
        }
        custom_group, created = CustomGroup.objects.get_or_create(**custom_group_data)

        if not created:
            raise serializers.ValidationError({'group': 'Role already exists'})

        for perm_id in permissions:
            try:
                permission = Permission.objects.get(id=perm_id)
                group.permissions.add(permission)
            except Permission.DoesNotExist:
                raise serializers.ValidationError({'permissions': f'Permission with id {perm_id} does not exist.'})

        for user_id in users:
            try:
                user = CustomUser.objects.get(id=user_id)
                custom_group.user.add(user)
            except CustomUser.DoesNotExist:
                raise serializers.ValidationError({'users': f'User with id {user_id} does not exist.'})

        return custom_group


    def to_representation(self, instance):
        representation = super().to_representation(instance)
        # Remove fields based on conditions
        if instance.university_id is None or instance.university_id == 0:
            representation.pop('university', None)
            representation.pop('university_name', None)
        if instance.campus_id is None or instance.campus_id == 0:
            representation.pop('campus', None)
            representation.pop('campus_name', None)
        if instance.department_id is None or instance.department_id == 0:
            representation.pop('department', None)
            representation.pop('department_name', None)
        return representation

    def to_internal_value(self, data):
        if 'university' in data and data['university'] == 0:
            data['university'] = None
        if 'campus' in data and data['campus'] == 0:
            data['campus'] = None
        if 'department' in data and data['department'] == 0:
            data['department'] = None
        return super().to_internal_value(data)


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