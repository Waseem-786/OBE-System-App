# Generated by Django 4.0.10 on 2024-04-22 17:18

from django.db import migrations, models
import django.db.models.deletion


class Migration(migrations.Migration):

    dependencies = [
        ('university_management', '0002_remove_batch_sections_batchsection'),
        ('program_management', '0002_plo_program'),
    ]

    operations = [
        migrations.AlterField(
            model_name='peo_plo_mapping',
            name='peo',
            field=models.ForeignKey(default=0, on_delete=django.db.models.deletion.CASCADE, to='program_management.peo'),
        ),
        migrations.AlterField(
            model_name='peo_plo_mapping',
            name='plo',
            field=models.ForeignKey(default=0, on_delete=django.db.models.deletion.CASCADE, to='program_management.plo'),
        ),
        migrations.AlterField(
            model_name='plo',
            name='program',
            field=models.ForeignKey(default=0, on_delete=django.db.models.deletion.CASCADE, to='university_management.department'),
        ),
    ]
