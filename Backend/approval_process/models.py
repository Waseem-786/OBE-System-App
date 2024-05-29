from django.db import models
from user_management.models import CustomGroup, CustomUser
from course_management.models import CourseLearningOutcomes
from program_management.models import PEO
from university_management.models import Campus


class ApprovalEntity(models.Model):
    ENTITY_CHOICES = [
        ('CLO', 'Course Learning Outcome'),
        ('PEO', 'Program Educational Objective')
    ]
    name = models.CharField(max_length=50, choices=ENTITY_CHOICES, unique=True)

    def __str__(self):
        return self.name


class ApprovalChain(models.Model):
    campus = models.ForeignKey(Campus, on_delete=models.CASCADE)
    custom_group = models.ForeignKey(CustomGroup, on_delete=models.CASCADE)
    entity = models.ForeignKey(ApprovalEntity, on_delete=models.CASCADE)
    order = models.IntegerField()

    class Meta:
        unique_together = ('campus', 'entity', 'order')
        ordering = ['order']

    def __str__(self):
        return f"{self.campus.name} - {self.custom_group.group.name} - {self.entity.name} - {self.order}"

class Approval(models.Model):
    entity_id = models.PositiveIntegerField()
    entity_type = models.ForeignKey(ApprovalEntity, on_delete=models.CASCADE)
    approved_by = models.ForeignKey(CustomUser, on_delete=models.CASCADE)
    approved_at = models.DateTimeField(auto_now_add=True)
    status = models.BooleanField()  # True for approved, False for rejected

    class Meta:
        unique_together = ('entity_id', 'entity_type', 'approved_by')
