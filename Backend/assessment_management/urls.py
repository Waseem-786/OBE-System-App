from django.urls import path
from . import views

urlpatterns = [
    path('complete-assessment', views.CompleteAssessmentCreateView.as_view(), name='create-complete-assessment'),
    path('complete-assessment/<int:assessment_id>', views.CompleteAssessmentDetailView.as_view(), name='manage-complete-assessment'),
    path('assessments', views.AllAssessmentsView.as_view(), name='all-assessments'),
    path('assessment/question/consistency', views.CheckQuestionConsistencyView.as_view(), name='check-question-consistency'),
    path('assessment/refine-complete', views.RefineCompleteAssessmentView.as_view(), name='refine-complete-assessment'),
]
