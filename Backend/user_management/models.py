from university_management.models import University
from djongo import models
from django.contrib.auth.models import AbstractUser
from django.contrib.auth.models import PermissionsMixin
from django.utils.translation import gettext_lazy as _

class CustomUser(AbstractUser, PermissionsMixin, models.Model):
    email = models.EmailField(_("email address"), unique=True)
    university = models.ForeignKey(University, on_delete=models.CASCADE, null=True, blank=True)