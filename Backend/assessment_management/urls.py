from django.urls import path
from . import views

urlpatterns = [
    path('assessment-creation',views.AssessmentView.as_view()),
    path('assessment-creation/<int:pk>',views.SingleAssessmentView.as_view()),
    
    path('assessment/question',views.QuestionView.as_view()),
    path('assessment/question/<int:pk>',views.SingleQuestionView.as_view()),
    
    path('assessment/question/part',views.QuestionPartView.as_view()),
    path('assessment/question/part/<int:pk>',views.QuestionPartView.as_view()),

    path('complete-assessment', views.AssessmentQuestionPartCreateView.as_view()),
]