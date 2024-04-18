from django.urls import path
from . import views

urlpatterns = [
    path('peo',views.PEO_View.as_view()),
    path('plo',views.PLO_View.as_view()),
    path('peo/plo/mapping',views.PEO_PLO_Mapping_View.as_view()),
]