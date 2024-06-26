# Generated by Django 4.0.10 on 2024-04-18 15:40

from django.db import migrations, models
import django.db.models.deletion


class Migration(migrations.Migration):

    initial = True

    dependencies = [
        ('university_management', '0002_remove_batch_sections_batchsection'),
    ]

    operations = [
        migrations.CreateModel(
            name='PEO',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('description', models.CharField(max_length=255)),
                ('program', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to='university_management.department')),
            ],
        ),
        migrations.CreateModel(
            name='PLO',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('name', models.CharField(max_length=50)),
                ('description', models.CharField(max_length=255)),
            ],
        ),
        migrations.CreateModel(
            name='PEO_PLO_Mapping',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('peo', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to='program_management.peo')),
                ('plo', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to='program_management.plo')),
            ],
            options={
                'unique_together': {('peo', 'plo')},
            },
        ),
    ]
