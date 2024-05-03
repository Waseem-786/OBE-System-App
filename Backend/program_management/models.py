from django.db import models
from university_management.models import Department
# Create your models here.
class PEO(models.Model):
    description = models.TextField()
    program = models.ForeignKey(Department, on_delete=models.CASCADE)

class PLO(models.Model):
    name = models.CharField(max_length=50)
    description = models.TextField()

class PEO_PLO_Mapping(models.Model):
    peo = models.ForeignKey(PEO, on_delete=models.CASCADE)
    plo = models.ForeignKey(PLO, on_delete=models.CASCADE)

    class Meta:
        unique_together = ('peo', 'plo')