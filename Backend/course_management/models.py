from django.db import models
from university_management.models import Department, Batch
from user_management.models import CustomUser
from university_management.models import Campus, Department
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
    campus = models.ForeignKey(Campus, on_delete=models.CASCADE)

class CourseObjective(models.Model):
    course = models.ForeignKey(CourseInformation, on_delete=models.CASCADE)
    description = models.TextField()
    
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
    clo = models.ManyToManyField(CourseLearningOutcomes)
    def __str__(self):
        return f"Course Assessment Structure for {self.course_outline}"


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

class WeeklyTopic(models.Model):
    WEEK_CHOICES = [
        (1, 'Week 1'),
        (2, 'Week 2'),
        (3, 'Week 3'),
        (4, 'Week 4'),
        (5, 'Week 5'),
        (7, 'Week 7'),
        (8, 'Week 8'),
        (10, 'Week 10'),
        (11, 'Week 11'),
        (13, 'Week 13'),
        (14, 'Week 14'),
        (15, 'Week 15'),
        (16, 'Week 16'),
    ]
    week_number = models.IntegerField(choices=WEEK_CHOICES)
    topic = models.CharField(max_length=255)
    description = models.TextField()
    course_outline = models.ForeignKey(CourseOutline, on_delete=models.CASCADE)
    clo = models.ManyToManyField(CourseLearningOutcomes)
    assessments = models.TextField()

    def __str__(self):
        return f"Week {self.week_number}: {self.topic}"
    

class CourseDepartment(models.Model):
    department = models.ForeignKey(Department, on_delete=models.CASCADE)
    course = models.ForeignKey(CourseInformation, on_delete=models.CASCADE)


class PLO_CLO_Mapping(models.Model):
    plo = models.ForeignKey(PLO, on_delete=models.CASCADE)
    clo = models.ForeignKey(CourseLearningOutcomes, on_delete=models.CASCADE)

    class Meta:
        unique_together = ('plo', 'clo')