from django.urls import path
from . import views

urlpatterns = [
    path('approval-chain', views.ApprovalChainCreateView.as_view(), name='create_approval_chain'),   
    path('approval-chains/<int:campus_id>', views.ApprovalChainByCampusView.as_view()),
    path('clo-update-request', views.CLOUpdateRequestCreateView.as_view(), name='create_clo_update_request'),   
    path('approve-reject-process/<int:pk>', views.ApprovalProcessUpdateView.as_view(), name='approve_reject_process'),   
]
