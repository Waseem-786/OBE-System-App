from django.contrib import admin
from .models import University, Campus, Department, Section, Batch
# Register your models here.
admin.site.register(University)
admin.site.register(Campus)
admin.site.register(Department)
admin.site.register(Section)
admin.site.register(Batch)