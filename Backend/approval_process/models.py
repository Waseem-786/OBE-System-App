from django.db import models
from university_management.models import University, Campus, Department
from user_management.models import CustomUser, CustomGroup
from course_management.models import CourseLearningOutcomes

class ApprovalStep(models.Model):
    name = models.CharField(max_length=100)
    group = models.ForeignKey(CustomGroup, on_delete=models.CASCADE)
    order = models.IntegerField()

    def __str__(self):
        return f"{self.name} (Order: {self.order})"

class ApprovalProcess(models.Model):
    clo = models.ForeignKey(CourseLearningOutcomes, on_delete=models.CASCADE, related_name='approval_processes')
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)
    current_step = models.ForeignKey(ApprovalStep, on_delete=models.SET_NULL, null=True, blank=True, related_name='current_processes')
    status = models.CharField(max_length=20, choices=[('pending', 'Pending'), ('approved', 'Approved'), ('rejected', 'Rejected')], default='pending')
    justification = models.TextField(blank=True, null=True)  # Justification for the update
    comment = models.TextField(blank=True, null=True)

    def __str__(self):
        return f"Approval Process for {self.clo} (Status: {self.status})"

class ApprovalLog(models.Model):
    process = models.ForeignKey(ApprovalProcess, on_delete=models.CASCADE, related_name='logs')
    step = models.ForeignKey(ApprovalStep, on_delete=models.CASCADE)
    user = models.ForeignKey(CustomUser, on_delete=models.CASCADE)
    status = models.CharField(max_length=20, choices=[('pending', 'Pending'), ('approved', 'Approved'), ('rejected', 'Rejected')])
    comment = models.TextField(blank=True, null=True)
    created_at = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return f"Log for {self.process} at {self.step} by {self.user} (Status: {self.status})"
