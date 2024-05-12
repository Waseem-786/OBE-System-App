from django.contrib import admin
from . import models
# Register your models here.
admin.site.register(models.CourseInformation)
admin.site.register(models.CourseObjective)
admin.site.register(models.CourseLearningOutcomes)
admin.site.register(models.CourseOutline)
admin.site.register(models.CourseAssessment)
admin.site.register(models.CourseSchedule)
admin.site.register(models.WeeklyTopic)
admin.site.register(models.CourseBooks)
admin.site.register(models.PLO_CLO_Mapping)
