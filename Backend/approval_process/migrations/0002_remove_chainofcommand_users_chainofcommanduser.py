# Generated by Django 4.0.10 on 2024-05-02 19:10

from django.conf import settings
from django.db import migrations, models
import django.db.models.deletion


class Migration(migrations.Migration):

    dependencies = [
        migrations.swappable_dependency(settings.AUTH_USER_MODEL),
        ('approval_process', '0001_initial'),
    ]

    operations = [
        migrations.RemoveField(
            model_name='chainofcommand',
            name='users',
        ),
        migrations.CreateModel(
            name='ChainOfCommandUser',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('order', models.IntegerField(default=0)),
                ('chain_of_command', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to='approval_process.chainofcommand')),
                ('user', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to=settings.AUTH_USER_MODEL)),
            ],
        ),
    ]
