from django.urls import path
from . import views
urlpatterns = [
    path('role/<int:pk>',views.SingleRole.as_view()),
    
    path('top/role',views.TopLevelRoles.as_view()),
    path('university/role/<int:university_id>',views.UniversityLevelRoles.as_view()),
    path('campus/role/<str:campus_id>',views.CampusLevelRoles.as_view()),
    path('department/role/<int:department_id>',views.DepartmentLevelRoles.as_view()),
    
    path('users',views.AllUsers.as_view()),
    path('user/<int:pk>',views.SingleUser.as_view()),
    path('university/<int:university_id>/users',views.AllUsers_for_SpecificUniversity.as_view()),
    path('campus/<int:campus_id>/users',views.AllUsers_for_SpecificCampus.as_view()),
    path('department/<int:department_id>/users',views.AllUsers_for_SpecificDepartment.as_view()),
    path('user/<int:user_id>/permissions',views.UserPermissionsView.as_view()),
    path('user/<int:user_id>/groups',views.UserGroupsView.as_view()),
    path('groups/<int:group_id>/users',views.GroupUsersView.as_view()),

    path('permissions',views.PermissionsView.as_view()),
    path('groups/<int:group_id>/permissions',views.GroupPermissionsView.as_view()),
]