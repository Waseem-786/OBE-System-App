# Generated by Django 4.0.10 on 2024-06-02 16:26

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('course_management', '0001_initial'),
    ]

    operations = [
        migrations.AddField(
            model_name='courseinformation',
            name='pec_content',
            field=models.TextField(default=''),
        ),
    ]