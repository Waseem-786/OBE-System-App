from django.urls import path
from .views import ApprovalChainViewSet, ApprovalViewSet, ApprovalEntityView

approval_chain_list = ApprovalChainViewSet.as_view({
    'get': 'list',
    'post': 'create'
})

approval_chain_detail = ApprovalChainViewSet.as_view({
    'get': 'retrieve',
    'put': 'update',
    'patch': 'partial_update',
    'delete': 'destroy'
})

approval_approve = ApprovalViewSet.as_view({
    'post': 'approve'
})

approval_reject = ApprovalViewSet.as_view({
    'post': 'reject'
})

urlpatterns = [
    path('approval-entity', ApprovalEntityView.as_view(), name='approval-entity-list-create'),
    path('approval-chains', approval_chain_list, name='approval-chain-list'),
    path('approval-chains/<int:pk>', approval_chain_detail, name='approval-chain-detail'),
    path('approvals/<int:pk>/approve', approval_approve, name='approval-approve'),
    path('approvals/<int:pk>/reject', approval_reject, name='approval-reject')
]
