from django.db import models
from university_management.models import Department, Batch
from user_management.models import CustomUser
from university_management.models import Campus
from program_management.models import PLO

class CourseInformation(models.Model):
    code = models.CharField(max_length=20)
    title = models.CharField(max_length=100)
    theory_credits = models.IntegerField()
    lab_credits = models.IntegerField()
    course_type = models.CharField(max_length=20)
    required_elective = models.CharField(max_length=20)
    prerequisite = models.ForeignKey('self', on_delete=models.CASCADE, null=True, blank=True, related_name='prerequisite_for')
    description = models.CharField(max_length=1000)
    pec_content = models.TextField(default="")
    campus = models.ForeignKey(Campus, on_delete=models.CASCADE)

    def __str__(self) -> str:
        return self.title    

class CourseObjective(models.Model):
    course = models.ForeignKey(CourseInformation, on_delete=models.CASCADE)
    description = models.TextField()

    def __str__(self) -> str:
        return self.description

class CourseLearningOutcomes(models.Model):
    course = models.ForeignKey(CourseInformation, on_delete=models.CASCADE)
    description = models.TextField()
    BLOOM_TAXONOMY_CHOICES = [
        ('Cognitive', 'Cognitive'),
        ('Psychomotor', 'Psychomotor'),
        ('Affective', 'Affective')
    ]
    bloom_taxonomy = models.CharField(max_length=20, choices=BLOOM_TAXONOMY_CHOICES)
    level = models.IntegerField()
    plo = models.ManyToManyField(PLO, related_name='clos')
    course_outline = models.ForeignKey('CourseOutline', on_delete=models.CASCADE, null=True, blank=True)

    def __str__(self) -> str:
        return self.description

class CourseOutline(models.Model):
    course = models.ForeignKey(CourseInformation, on_delete=models.CASCADE)
    batch = models.ForeignKey(Batch, on_delete=models.CASCADE)
    teacher = models.ForeignKey(CustomUser, on_delete=models.CASCADE)
    class Meta:
        unique_together = ('course', 'batch', 'teacher')

class CourseSchedule(models.Model):
    course_outline = models.OneToOneField(CourseOutline, on_delete=models.CASCADE)
    lecture_hours_per_week = models.IntegerField()
    lab_hours_per_week = models.IntegerField()
    discussion_hours_per_week = models.IntegerField()
    office_hours_per_week = models.IntegerField()

class CourseAssessment(models.Model):
    course_outline = models.ForeignKey(CourseOutline, on_delete=models.CASCADE)
    name = models.CharField(max_length=255)
    count = models.IntegerField()
    weight = models.DecimalField(max_digits=5, decimal_places=2)
    clo = models.ManyToManyField(CourseLearningOutcomes, related_name='assessments')
    week = models.ForeignKey('WeeklyTopic', on_delete=models.CASCADE, null=True, blank=True)

    def __str__(self):
        return self.name

class CourseBooks(models.Model):
    course_outline = models.ForeignKey(CourseOutline, on_delete=models.CASCADE)
    title = models.TextField()
    BOOK_TYPES = [
        ('Reference', 'Reference'),
        ('Text', 'Text'),
    ]
    book_type = models.CharField(max_length=20, choices=BOOK_TYPES)
    description = models.TextField()
    link = models.URLField()

    def __str__(self) -> str:
        return self.title

class WeeklyTopic(models.Model):
    WEEK_CHOICES = [(i, f'Week {i}') for i in range(1, 17)]
    week_number = models.IntegerField(choices=WEEK_CHOICES)
    topic = models.CharField(max_length=255)
    description = models.TextField()
    course_outline = models.ForeignKey(CourseOutline, on_delete=models.CASCADE)

    def __str__(self):
        return f"Week {self.week_number}: {self.topic}"
