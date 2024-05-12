# from django.db import models
# from user_management.models import CustomGroup

# class EntityType(models.Model):
#     name = models.CharField(max_length=100, unique=True)

#     def __str__(self):
#         return self.name

# class ApprovalGroup(models.Model):
#     entity_type = models.ForeignKey(EntityType, on_delete=models.CASCADE)
#     group = models.ForeignKey(CustomGroup, on_delete=models.CASCADE)
#     order = models.PositiveIntegerField()  # Lower order goes first in approval chain
#     status = models.CharField(max_length=20, choices=[
#         ('Pending', 'Pending'),
#         ('Approved', 'Approved'),
#         ('Rejected', 'Rejected'),
#     ], default='Pending')

#     class Meta:
#         unique_together = (('entity_type', 'order'),)  # Ensure unique order per entity type

# class ApprovalRequest(models.Model):
#     entity_type = models.ForeignKey(EntityType, on_delete=models.CASCADE)
#     entity_id = models.PositiveIntegerField()  # Reference ID for the updated entity
#     previous_data = models.JSONField(blank=True, null=True)  # Store previous data
#     new_data = models.JSONField()
#     justification = models.TextField()
#     status = models.CharField(max_length=20, choices=[
#         ('Pending', 'Pending'),
#         ('Approved', 'Approved'),
#         ('Rejected', 'Rejected'),
#     ], default='Pending')
#     created_at = models.DateTimeField(auto_now_add=True)
#     updated_at = models.DateTimeField(auto_now=True)

#     def __str__(self):
#         return f"Approval for {self.entity_type} (ID: {self.entity_id})"
