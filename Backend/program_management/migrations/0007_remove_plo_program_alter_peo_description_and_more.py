# Generated by Django 4.0.10 on 2024-04-30 17:05

from django.db import migrations, models
import django.db.models.deletion


class Migration(migrations.Migration):

    dependencies = [
        ('program_management', '0006_alter_plo_name'),
    ]

    operations = [
        migrations.RemoveField(
            model_name='plo',
            name='program',
        ),
        migrations.AlterField(
            model_name='peo',
            name='description',
            field=models.TextField(),
        ),
        migrations.AlterField(
            model_name='peo_plo_mapping',
            name='peo',
            field=models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to='program_management.peo'),
        ),
        migrations.AlterField(
            model_name='peo_plo_mapping',
            name='plo',
            field=models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to='program_management.plo'),
        ),
        migrations.AlterField(
            model_name='plo',
            name='description',
            field=models.TextField(),
        ),
    ]
