# Generated by Django 4.0.10 on 2024-05-02 19:10

from django.conf import settings
from django.db import migrations


class Migration(migrations.Migration):

    dependencies = [
        migrations.swappable_dependency(settings.AUTH_USER_MODEL),
        ('university_management', '0002_remove_batch_sections_batchsection'),
        ('course_management', '0002_coursebooks_delete_coursebook'),
    ]

    operations = [
        migrations.AlterUniqueTogether(
            name='courseoutline',
            unique_together={('course', 'batch', 'teacher')},
        ),
    ]