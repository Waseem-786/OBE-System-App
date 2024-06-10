from django.urls import path
from . import views

urlpatterns = [
    path('course', views.CourseInformationView.as_view()),
    path('course/<int:pk>', views.SingleCourseView.as_view()),
    path('campus/<int:pk>/course', views.Course_of_Specific_Campus.as_view()),

    path('clo', views.CourseLearningOutcomesView.as_view()),
    path('course/<int:pk>/clo', views.CLO_of_Specific_Course.as_view()),
    path('clo/<int:pk>', views.SingleCLO.as_view()),
    path('clo/update', views.CLOUpdateView.as_view()),
    path('CLOdata', views.CLODataView.as_view()),
    path('clo/generate', views.GenerateCLOsView.as_view()),

    path('objective', views.CourseObjectiveCreateView.as_view()),
    path('course/<int:pk>/objective', views.CourseObjective_SpecificCourse_View.as_view()),
    path('objective/<int:pk>', views.SingleCourseObjectiveView.as_view()),

    path('outline', views.CourseOutlineCreateView.as_view()),
    path('course/<int:pk>/outline', views.CourseOutline_SpecificCourse_View.as_view()),
    path('batch/<int:pk>/outline', views.CourseOutline_SpecificBatch_View.as_view()),  
    path('user/<int:pk>/outline', views.CourseOutline_SpecificTeacher_View.as_view()),
    path('outline/<int:pk>', views.SingleCourseOutlineView.as_view()),
    path('complete-outline/<int:pk>', views.CompleteOutlineView.as_view()),
    path('create/complete-outline', views.CreateCompleteOutlineView.as_view()),

    path('schedule', views.CourseScheduleCreateView.as_view()),
    path('outline/<int:pk>/schedule', views.CourseSchedule_SpecificOutline_View.as_view()),
    path('schedule/<int:pk>', views.SingleCourseScheduleView.as_view()),

    path('assessment', views.CourseAssessmentCreateView.as_view()),
    path('outline/<int:pk>/assessment', views.CourseAssessment_SpecificOutline_View.as_view()),
    path('assessment/<int:pk>', views.SingleCourseAssessmentView.as_view()),

    path('book', views.CourseBookCreateView.as_view()),
    path('outline/<int:pk>/book', views.CourseBook_SpecificOutline_View.as_view()),
    path('outline/<int:pk>/book/text', views.Text_CourseBook.as_view()),
    path('outline/<int:pk>/book/reference', views.Reference_CourseBook.as_view()),
    path('book/<int:pk>', views.SingleCourseBookView.as_view()),

    path('weekly-topics', views.WeeklyTopicCreateView.as_view(), name='weekly-topic-list'),
    path('weekly-topics/generate', views.WeeklyTopicGenerateView.as_view(), name='weekly-topic-list'),
    path('outline/<int:pk>/weekly-topics', views.WeeklyTopic_SpecificOutline_View.as_view()),
    path('weekly-topics/<int:pk>', views.WeeklyTopicRetrieveUpdateDestroy.as_view(), name='weekly-topic-detail'),
]