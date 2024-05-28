from django.db import models
from user_management.models import CustomUser
from university_management.models import Batch
from course_management.models import CourseInformation, CourseLearningOutcomes

class Assessment(models.Model):
    """
    Represents an assessment (e.g., assignment, quiz) created by a teacher for a specific course and batch.
    """
    name = models.CharField(max_length=100)
    teacher = models.ForeignKey(CustomUser, on_delete=models.CASCADE, related_name='created_assessments')
    batch = models.ForeignKey(Batch, on_delete=models.CASCADE, related_name='assessments')
    course = models.ForeignKey(CourseInformation, on_delete=models.CASCADE, related_name='assessments')
    total_marks = models.PositiveIntegerField()
    duration = models.DurationField()
    instruction = models.TextField()

class Question(models.Model):
    """
    Represents a question within an assessment.
    """
    description = models.TextField()
    assessment = models.ForeignKey(Assessment, on_delete=models.CASCADE, related_name='questions')
    clo = models.ManyToManyField(CourseLearningOutcomes, related_name='questions')

class QuestionPart(models.Model):
    """
    Represents a part or sub-question within a question.
    """
    question = models.ForeignKey(Question, on_delete=models.CASCADE, related_name='parts')
    description = models.TextField()
    marks = models.PositiveIntegerField()
