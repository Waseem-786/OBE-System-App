from django.db import models
from django.contrib.auth.models import AbstractUser
from university_management.models import University

class CustomUser(AbstractUser):
    email = models.EmailField(unique=True)  # Define email field as required and unique
    university = models.ForeignKey(University, on_delete=models.CASCADE, null=True, blank=True)
