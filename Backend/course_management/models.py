from django.db import models
from university_management.models import Department, Batch
from user_management.models import CustomUser
# Create your models here.
class CourseInformation(models.Model):
    code = models.CharField(max_length=20)
    title = models.CharField(max_length=100)
    theory_credits = models.IntegerField()
    lab_credits = models.IntegerField()
    course_type = models.CharField(max_length=20)
    required_elective = models.CharField(max_length=20)
    prerequisite = models.ForeignKey('self', on_delete=models.CASCADE, null=True, blank=True, related_name='prerequisite_for')
    description = models.CharField(max_length=255)

    
class CourseOutline(models.Model):
     batch = models.ForeignKey(Batch, on_delete=models.CASCADE)
     teacher = models.ForeignKey(CustomUser, on_delete=models.CASCADE)

class CourseSchedule(models.Model):
    lecture_hours_per_week = models.IntegerField(default=2)
    lab_hours_per_week = models.IntegerField(default=0)
    discussion_hours_per_week = models.IntegerField(default=1)
    office_hours_per_week = models.IntegerField(default=2)

class CourseAssessment(models.Model):
    exam = models.CharField(max_length=255)
    assignments = models.IntegerField()
    lab_reports = models.IntegerField(default=0)
    design_reports = models.IntegerField(default=0)
    quizzes = models.IntegerField()
    
class Grading(models.Model):
    # Adding weightings for each component
    quizzes_weight = models.DecimalField(max_digits=5, decimal_places=2, default=0.0)
    assignments_weight = models.DecimalField(max_digits=5, decimal_places=2, default=0.0)
    mid_term_weight = models.DecimalField(max_digits=5, decimal_places=2, default=0.0)
    final_weight = models.DecimalField(max_digits=5, decimal_places=2, default=0.0)
    course_assessment = models.OneToOneField(CourseAssessment, on_delete=models.CASCADE)

class Book(models.Model):
    title = models.CharField(max_length=255)
    author = models.CharField(max_length=255)
    category = models.CharField(max_length=100)  # You can add more fields like ISBN, publication year, etc.

class Reference(models.Model):
    book = models.ForeignKey(Book, on_delete=models.CASCADE, related_name='references')
    description = models.TextField()
    link = models.URLField()

class Text(models.Model):
    book = models.ForeignKey(Book, on_delete=models.CASCADE, related_name='texts')
    description = models.TextField()
    link = models.URLField()


class CourseObjective(models.Model):
    course = models.ForeignKey(CourseInformation, on_delete=models.CASCADE, related_name='objectives')
    description = models.TextField()



class CourseLearningOutcomes(models.Model):
    number = models.CharField(max_length=10)
    description = models.CharField(max_length=255)
    BLOOM_TAXONOMY_CHOICES = [
        ('Cognitive', 'Cognitive'),
        ('Psychomotor', 'Psychomotor'),
        ('Affective', 'Affective')
    ]
    bloom_taxonomy = models.CharField(max_length=20, choices=BLOOM_TAXONOMY_CHOICES)
    level = models.IntegerField()




# class Curriculum(models.Model):
#     name = models.CharField(max_length=200)
#     batches = models.ManyToManyField(Batch, related_name='curriculums')
#     courses = models.ManyToManyField(Course, related_name='curriculums')