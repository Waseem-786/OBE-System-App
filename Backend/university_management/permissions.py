from django.shortcuts import get_object_or_404
from rest_framework import permissions
from user_management.models import CustomUser
from user_management.permissions import IsSuperUser

class IsUserUniversity(permissions.BasePermission):
    """
    Custom permission to only allow university data if users belongs to that specific university.
    """

    def has_permission(self, request, view):
        # Check if the requested university ID is valid
        university_id = view.kwargs.get('pk')
        if not university_id:
            return False
        
        User = get_object_or_404(CustomUser, id=request.user.id)

        # Instantiate IsSuperUser permission class
        is_super_user = IsSuperUser()

        # Check if the user is a superuser
        if is_super_user.has_permission(request, view):
            return True
        
        # Check if the user belongs to the requested university
        return User.university.id == university_id
    
class IsUserCampus(permissions.BasePermission):
    """
    Custom permission to only allow campus data if users belongs to that specific campus.
    """

    def has_permission(self, request, view):
        # Check if the requested university ID is valid
        campus_id = view.kwargs.get('pk')
        if not campus_id:
            return False
        
        User = get_object_or_404(CustomUser, id=request.user.id)

        # Instantiate IsSuperUser permission class
        is_super_user = IsSuperUser()

        # Check if the user is a superuser
        if is_super_user.has_permission(request, view):
            return True
        
        # Check if the user belongs to the requested university
        return User.campus.id == campus_id
    
class IsUserDepartment(permissions.BasePermission):
    """
    Custom permission to only allow department data if users belongs to that specific department.
    """

    def has_permission(self, request, view):
        # Check if the requested university ID is valid
        department_id = view.kwargs.get('pk')
        if not department_id:
            return False
        
        User = get_object_or_404(CustomUser, id=request.user.id)

        # Instantiate IsSuperUser permission class
        is_super_user = IsSuperUser()

        # Check if the user is a superuser
        if is_super_user.has_permission(request, view):
            return True
        
        # Check if the user belongs to the requested university
        return User.department.id == department_id