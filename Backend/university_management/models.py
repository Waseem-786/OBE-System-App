from django.db import models

class University(models.Model):
    name = models.CharField(max_length=100)
    vision = models.TextField(blank=True)
    mission = models.TextField(blank=True)

    def __str__(self):
        return self.name

class Campus(models.Model):
    name = models.CharField(max_length=100)
    location = models.CharField(max_length=100)
    university = models.ForeignKey(University, on_delete=models.CASCADE, related_name='campuses')

    def __str__(self):
        return f"{self.name} - {self.university.name}"