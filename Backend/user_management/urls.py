from django.urls import path
from . import views
urlpatterns = [
    path('role',views.Roles.as_view()),
    path('role/<int:pk>',views.SingleRole.as_view()),
    path('user-group/<str:group>', views.AddUserToGroupView.as_view(), name='add_user_to_group'),
]