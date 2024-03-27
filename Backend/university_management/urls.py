from django.urls import path
from . import views

urlpatterns = [
    path('university',views.UniversityView.as_view()),
    path('campus',views.CampusView.as_view()),
]