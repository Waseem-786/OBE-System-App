# Generated by Django 4.0.10 on 2024-05-28 16:50

from django.conf import settings
from django.db import migrations, models
import django.db.models.deletion


class Migration(migrations.Migration):

    initial = True

    dependencies = [
        ('university_management', '0004_alter_section_name'),
        migrations.swappable_dependency(settings.AUTH_USER_MODEL),
        ('user_management', '0002_customgroup_user'),
    ]

    operations = [
        migrations.CreateModel(
            name='ApprovalEntity',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('name', models.CharField(choices=[('CLO', 'Course Learning Outcome'), ('PEO', 'Program Educational Objective')], max_length=50, unique=True)),
            ],
        ),
        migrations.CreateModel(
            name='ApprovalChain',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('order', models.IntegerField()),
                ('campus', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to='university_management.campus')),
                ('custom_group', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to='user_management.customgroup')),
                ('entity', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to='approval_process.approvalentity')),
            ],
            options={
                'ordering': ['order'],
                'unique_together': {('campus', 'entity', 'order')},
            },
        ),
        migrations.CreateModel(
            name='Approval',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('entity_id', models.PositiveIntegerField()),
                ('approved_at', models.DateTimeField(auto_now_add=True)),
                ('status', models.BooleanField()),
                ('approved_by', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to=settings.AUTH_USER_MODEL)),
                ('entity_type', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to='approval_process.approvalentity')),
            ],
            options={
                'unique_together': {('entity_id', 'entity_type', 'approved_by')},
            },
        ),
    ]