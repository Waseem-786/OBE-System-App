from university_management.models import University, Campus, Department
from django.db import models
from django.contrib.auth.models import AbstractUser, Group, Permission
from django.utils.translation import gettext_lazy as _
from django.core.exceptions import ValidationError

class CustomUser(AbstractUser):
    email = models.EmailField(_("email address"), unique=True)
    first_name = models.CharField(_("first name"), max_length=150)
    last_name = models.CharField(_("last name"), max_length=150)
    university = models.ForeignKey(University, on_delete=models.CASCADE, blank=True, default=0)
    campus = models.ForeignKey(Campus, on_delete=models.CASCADE, blank=True, default=0)
    department = models.ForeignKey(Department, on_delete=models.CASCADE, blank=True, default=0)


class CustomGroup(models.Model):
    university = models.ForeignKey(University, on_delete=models.CASCADE, null=True, default=0)
    campus = models.ForeignKey(Campus, on_delete=models.CASCADE, null=True, default=0)
    department = models.ForeignKey(Department, on_delete=models.CASCADE, null=True, default=0)
    group = models.ForeignKey(Group, on_delete=models.CASCADE, null=False)
    user = models.ManyToManyField(CustomUser, related_name='custom_groups', blank=True)


    class Meta:
        unique_together = ('university', 'campus', 'department', 'group')

    def __str__(self) -> str:
        return self.group.name