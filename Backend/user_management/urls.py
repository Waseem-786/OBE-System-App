from django.urls import path
from . import views
urlpatterns = [
    path('top/role',views.TopLevelRoles.as_view()),
    path('university/role/<str:university_name>',views.UniversityLevelRoles.as_view()),
    path('campus/role/<str:campus_name>',views.CampusLevelRoles.as_view()),
    path('department/role/<str:department_name>',views.DepartmentLevelRoles.as_view()),
    path('top/role/assign/<str:group_name>',views.AddUserToTopLevelGroupView.as_view()),
    path('university/role/assign/<str:group_name>',views.AddUserToUniversityLevelGroupView.as_view()),
    path('campus/role/assign/<str:group_name>',views.AddUserToCampusLevelGroupView.as_view()),
    path('department/role/assign/<str:group_name>',views.AddUserToDepartmentLevelGroupView.as_view()),
    path('users',views.AllUsers.as_view()),
    path('permissions',views.PermissionsView.as_view()),
    path('groups/<int:group_id>/permissions',views.GroupPermissionsView.as_view()),
]