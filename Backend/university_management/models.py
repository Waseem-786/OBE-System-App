from django.db import models

class University(models.Model):
    name = models.CharField(max_length=100)
    vision = models.TextField()
    mission = models.TextField()

    def __str__(self):
        return self.name

class Campus(models.Model):
    name = models.CharField(max_length=100)
    vision = models.TextField()
    mission = models.TextField()
    university = models.ForeignKey(University, on_delete=models.CASCADE, related_name='campuses')

    def __str__(self):
        return f"{self.name}"
    
class Department(models.Model):
    name = models.CharField(max_length=100)
    vision = models.TextField()
    mission = models.TextField()
    campus = models.ForeignKey(Campus, on_delete=models.CASCADE, related_name='departments')

    def __str__(self) -> str:
        return f"{self.name} - {self.campus.name} - {self.campus.university.name}"

class Batch(models.Model):
    name = models.CharField(max_length=200)
    department = models.ForeignKey(Department,on_delete=models.CASCADE,related_name='batch')

class Section(models.Model):
    name = models.CharField(max_length=200)

class BatchSection(models.Model):
    batch = models.ForeignKey(Batch, on_delete=models.CASCADE)
    section = models.ForeignKey(Section, on_delete=models.CASCADE)
    class Meta:
        unique_together = ('batch', 'section')