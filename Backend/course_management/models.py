from django.db import models
from university_management.models import Department, Batch
# Create your models here.
class Course(models.Model):
    code = models.CharField(max_length=20)
    title = models.CharField(max_length=100)
    name = models.CharField(max_length=200)
    course_type = models.CharField(max_length=20)
    required_elective = models.CharField(max_length=20)
    prerequisite = models.ForeignKey('self', on_delete=models.CASCADE, null=True, blank=True, related_name='prerequisite_for')

    
class Curriculum(models.Model):
    name = models.CharField(max_length=200)
    batches = models.ManyToManyField(Batch, related_name='curriculums')
    courses = models.ManyToManyField(Course, related_name='curriculums')