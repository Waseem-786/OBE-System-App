# Generated by Django 4.0.10 on 2024-06-08 10:22

from django.conf import settings
from django.db import migrations, models
import django.db.models.deletion


class Migration(migrations.Migration):

    initial = True

    dependencies = [
        ('course_management', '0001_initial'),
        migrations.swappable_dependency(settings.AUTH_USER_MODEL),
        ('approval_process', '0001_initial'),
    ]

    operations = [
        migrations.AddField(
            model_name='approvalprocess',
            name='clo',
            field=models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, related_name='approval_processes', to='course_management.courselearningoutcomes'),
        ),
        migrations.AddField(
            model_name='approvalprocess',
            name='current_step',
            field=models.ForeignKey(blank=True, null=True, on_delete=django.db.models.deletion.SET_NULL, related_name='current_processes', to='approval_process.approvalstep'),
        ),
        migrations.AddField(
            model_name='approvallog',
            name='process',
            field=models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, related_name='logs', to='approval_process.approvalprocess'),
        ),
        migrations.AddField(
            model_name='approvallog',
            name='step',
            field=models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to='approval_process.approvalstep'),
        ),
        migrations.AddField(
            model_name='approvallog',
            name='user',
            field=models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to=settings.AUTH_USER_MODEL),
        ),
    ]
