from django.urls import path
from . import views
urlpatterns = [
    path('role',views.Roles.as_view()),
    path('role/<int:pk>',views.SingleRole.as_view()),
]