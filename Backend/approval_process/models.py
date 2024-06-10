from django.db import models
from user_management.models import CustomUser, CustomGroup
from university_management.models import Campus
from course_management.models import CourseInformation

class ApprovalStep(models.Model):
    role = models.ForeignKey(CustomGroup, on_delete=models.CASCADE)
    step_number = models.IntegerField()

    def __str__(self):
        return f"{self.role.name} (Step {self.step_number})"

class ApprovalChain(models.Model):
    campus = models.ForeignKey(Campus, on_delete=models.CASCADE)
    steps = models.ManyToManyField(ApprovalStep, through='ApprovalChainStep')

    def __str__(self):
        return f"{self.campus.name}"

class ApprovalChainStep(models.Model):
    approval_chain = models.ForeignKey(ApprovalChain, on_delete=models.CASCADE)
    approval_step = models.ForeignKey(ApprovalStep, on_delete=models.CASCADE)
    order = models.IntegerField()

    class Meta:
        ordering = ['order']

class CLOUpdateRequest(models.Model):
    course = models.ForeignKey(CourseInformation, on_delete=models.CASCADE)
    requested_by = models.ForeignKey(CustomUser, on_delete=models.CASCADE)
    justification = models.TextField()
    clos = models.JSONField()  # Store CLOs in JSON format
    created_at = models.DateTimeField(auto_now_add=True)
    status = models.CharField(max_length=50, default='Pending')

    def __str__(self):
        return f"{self.course.name} - {self.requested_by.username} ({self.status})"

class ApprovalProcess(models.Model):
    clo_update_request = models.ForeignKey(CLOUpdateRequest, on_delete=models.CASCADE)
    current_step = models.ForeignKey(ApprovalStep, on_delete=models.CASCADE)
    approved_by = models.ForeignKey(CustomUser, null=True, blank=True, on_delete=models.SET_NULL, related_name='approved_by')
    status = models.CharField(max_length=50, default='Pending')
    justification = models.TextField(blank=True, null=True)
    created_at = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return f"{self.clo_update_request} - {self.current_step.role.name} ({self.status})"
