# Generated by Django 4.0.10 on 2024-03-23 10:00

from django.db import migrations, models
import django.db.models.deletion


class Migration(migrations.Migration):

    dependencies = [
        ('university_management', '0001_initial'),
    ]

    operations = [
        migrations.CreateModel(
            name='Section',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('name', models.CharField(max_length=200)),
            ],
        ),
        migrations.RemoveField(
            model_name='campus',
            name='location',
        ),
        migrations.AddField(
            model_name='campus',
            name='mission',
            field=models.TextField(default=''),
        ),
        migrations.AddField(
            model_name='campus',
            name='vision',
            field=models.TextField(default=''),
        ),
        migrations.AlterField(
            model_name='university',
            name='mission',
            field=models.TextField(),
        ),
        migrations.AlterField(
            model_name='university',
            name='vision',
            field=models.TextField(),
        ),
        migrations.CreateModel(
            name='Department',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('name', models.CharField(max_length=100)),
                ('vision', models.TextField()),
                ('mission', models.TextField()),
                ('campus', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, related_name='departments', to='university_management.campus')),
            ],
        ),
        migrations.CreateModel(
            name='Batch',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('name', models.CharField(max_length=200)),
                ('department', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, related_name='batch', to='university_management.department')),
                ('sections', models.ManyToManyField(related_name='batches', to='university_management.section')),
            ],
        ),
    ]
