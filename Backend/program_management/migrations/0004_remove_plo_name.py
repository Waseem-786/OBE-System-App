# Generated by Django 4.0.10 on 2024-04-22 18:35

from django.db import migrations


class Migration(migrations.Migration):

    dependencies = [
        ('program_management', '0003_alter_peo_plo_mapping_peo_alter_peo_plo_mapping_plo_and_more'),
    ]

    operations = [
        migrations.RemoveField(
            model_name='plo',
            name='name',
        ),
    ]
