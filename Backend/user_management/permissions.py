from rest_framework.permissions import BasePermission
from user_management.models import CustomUser, CustomGroup
from django.contrib.auth.models import Group
from django.shortcuts import get_object_or_404
class BaseGroupPermission(BasePermission):
    """
    Base permission class for checking group membership.
    """
    
    group_name = None

    def has_permission(self, request, view):
        try:
            group = Group.objects.get(name=self.group_name)
            custom_group = CustomGroup.objects.get(group=group)
        except CustomGroup.DoesNotExist:
            return False
        
        user = get_object_or_404(CustomUser, id=request.user.id)
        return user in custom_group.user.all()

class IsSuperUser(BasePermission):
    """
    Allows access only to superusers.
    """

    def has_permission(self, request, view):
        return CustomUser.objects.filter(pk=request.user.pk, is_superuser__in=[True]).exists()

class IsUniversityAdmin(BaseGroupPermission):
    """
    Allows access only to university admins.
    """
    
    group_name = 'university_admin'

class IsCampusAdmin(BaseGroupPermission):
    """
    Allows access only to campus admins.
    """

    group_name = 'campus_admin'

class IsDepartmentAdmin(BaseGroupPermission):
    """
    Allows access only to department admins.
    """

    group_name = 'department_admin'


class BaseSuperUserPermission(BasePermission):
    """
    Base permission class for allowing access to superusers or specific groups.
    """
    groups = []

    def get_group_objects(self):
        group_objects = []
        for group_name in self.groups:
            try:
                # Retrieve the Group object by its name
                group = Group.objects.get(name=group_name)
                # Retrieve the corresponding CustomGroup object
                custom_group = CustomGroup.objects.get(group=group)
                group_objects.append(custom_group)
            except Group.DoesNotExist:
                pass  # Ignore non-existent groups
            except CustomGroup.DoesNotExist:
                pass  # Ignore non-existent CustomGroup instances
        return group_objects
    
    def has_permission(self, request, view):
        is_superuser = CustomUser.objects.filter(pk=request.user.pk, is_superuser__in=[True]).exists()
        group_objects = self.get_group_objects()
        if not group_objects:
            # If no required group exists, return False
            return False

        user = get_object_or_404(CustomUser, id=request.user.id)
        group_exists = any(user in group.user.all() for group in group_objects)
        return is_superuser or group_exists

class IsSuper_University(BaseSuperUserPermission):
    """
    Allows access only to superusers or university admins.
    """
    groups = ['university_admin']

class IsSuper_University_Campus(BaseSuperUserPermission):
    """
    Allows access only to superusers, university admins, or campus admins.
    """
    groups = ['university_admin', 'campus_admin']

class IsSuper_University_Campus_Department(BaseSuperUserPermission):
    """
    Allows access only to superusers, university admins, campus admins, or department admins.
    """
    groups = ['university_admin', 'campus_admin', 'department_admin']
