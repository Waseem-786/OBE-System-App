# Generated by Django 4.0.10 on 2024-04-30 16:37

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('program_management', '0005_plo_name'),
    ]

    operations = [
        migrations.AlterField(
            model_name='plo',
            name='name',
            field=models.CharField(default=0, max_length=50),
            preserve_default=False,
        ),
    ]
