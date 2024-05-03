from django.urls import path
from . import views

urlpatterns = [
    path('university',views.UniversityView.as_view()),
    path('university/<int:pk>',views.SingleUniversityView.as_view()),
    path('campus',views.CampusView.as_view()),
    path('campus/<int:pk>',views.SingleCampusView.as_view()),
    path('university/<int:university_id>/campus',views.AllCampuses_For_SpecificUniversity_View.as_view()),
    path('department',views.DepartmentView.as_view()),
    path('department/<int:pk>',views.SingleDepartmentView.as_view()),
    path('campus/<int:campus_id>/department',views.AllDepartment_For_SpecificCampus_View.as_view()),
    path('batch',views.BatchView.as_view()),
    path('batch/<int:pk>',views.SingleBatchView.as_view()),
    path('section/<int:batchId>',views.SectionView.as_view()),
]