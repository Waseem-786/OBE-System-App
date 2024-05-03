from django.db import models
from user_management.models import CustomUser
from university_management.models import University, Campus

class ChainOfCommand(models.Model):
    ENTITY_TYPE_CHOICES = [
        ('CLO', 'CLO'),
        ('PLO', 'PLO'),
        # Add more entity types as needed
    ]
    
    SCOPE_CHOICES = [
        ('University', 'University'),
        ('Campus', 'Campus'),
    ]

    entity_type = models.CharField(max_length=100, choices=ENTITY_TYPE_CHOICES)
    scope = models.CharField(max_length=100, choices=SCOPE_CHOICES)
    university = models.ForeignKey(University, on_delete=models.CASCADE, null=True, blank=True)
    campus = models.ForeignKey(Campus, on_delete=models.CASCADE, null=True, blank=True)
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

# Model for recording the approval status for different entities
class Approval(models.Model):
    STATUS_CHOICES = [
        ('Pending', 'Pending'),
        ('Approved', 'Approved'),
        ('Rejected', 'Rejected'),
    ]

    entity_type = models.CharField(max_length=100)  # Example: 'CLO', 'PEO', etc.
    entity_id = models.IntegerField()  # ID of the entity being approved
    status = models.CharField(max_length=20, choices=STATUS_CHOICES, default='Pending')
    approved_by = models.ForeignKey(CustomUser, on_delete=models.SET_NULL, null=True, related_name='%(class)s_approved_by')
    rejected_by = models.ForeignKey(CustomUser, on_delete=models.SET_NULL, null=True, related_name='%(class)s_rejected_by')
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

class ChainOfCommandUser(models.Model):
    chain_of_command = models.ForeignKey(ChainOfCommand, on_delete=models.CASCADE)
    user = models.ForeignKey(CustomUser, on_delete=models.CASCADE)
    order = models.IntegerField(default=0)
