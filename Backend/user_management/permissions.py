from rest_framework.permissions import BasePermission
from user_management.models import CustomUser

class IsSuperUser(BasePermission):
    """
    Allows access only to superusers.
    """

    def has_permission(self, request, view):
        return CustomUser.objects.filter(pk=request.user.pk, is_superuser__in=[True]).exists()
