from django.urls import path
from . import views

urlpatterns = [
    path('university',views.UniversityView.as_view()),
    path('campus',views.CampusView.as_view()),
    path('department',views.DepartmentView.as_view()),
    path('batch',views.BatchView.as_view()),
    path('section',views.SectionView.as_view()),
]