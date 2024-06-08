from django.urls import path
from .views import ApprovalProcessCreateView, ApprovalProcessDetailView, ApprovalProcessActionView

urlpatterns = [
    path('approval-process', ApprovalProcessCreateView.as_view(), name='approval-process-create'),
    path('approval-process/<int:pk>', ApprovalProcessDetailView.as_view(), name='approval-process-detail'),
    path('approval-process/<int:pk>/<str:action>', ApprovalProcessActionView.as_view(), name='approval-process-action'),
]
