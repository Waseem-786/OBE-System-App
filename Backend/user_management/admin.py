from django.contrib import admin
from django.contrib.auth.admin import UserAdmin
from .models import CustomUser, CustomGroup
# Register CustomUser with appropriate admin settings
admin.site.register(CustomUser, UserAdmin)

# Register CustomGroup with appropriate admin settings
admin.site.register(CustomGroup)
