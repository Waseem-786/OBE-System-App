from django.urls import path
from . import views

urlpatterns = [
    path('peo',views.PEO_View.as_view()),
    path('peo/<int:pk>',views.SinglePEO_View.as_view()),
    path('plo',views.PLO_View.as_view()),
    path('plo/<int:pk>',views.SinglePLO_View.as_view()),
    path('peo/plo/mapping',views.PEO_PLO_Mapping_View.as_view()),
    path('program/<int:program_id>/peo',views.ALL_PEO_For_Specific_Program.as_view()),

    path('consistency_check/<int:department_id>', views.PEOConsistencyView.as_view()),
    path('generate/peo/<int:department_id>', views.GeneratePEOView.as_view()),

]