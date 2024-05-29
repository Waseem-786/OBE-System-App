from rest_framework import viewsets, status
from rest_framework import generics
from rest_framework.response import Response
from rest_framework.decorators import action
from .models import ApprovalChain, ApprovalEntity, Approval
from .serializers import ApprovalChainSerializer, ApprovalEntitySerializer, ApprovalSerializer
from user_management.models import CustomUser

class ApprovalEntityView(generics.ListCreateAPIView):
    queryset = ApprovalEntity.objects.all()
    serializer_class = ApprovalEntitySerializer

    def create(self, request, *args, **kwargs):
        serializer = self.get_serializer(data=request.data)
        serializer.is_valid(raise_exception=True)
        self.perform_create(serializer)
        headers = self.get_success_headers(serializer.data)
        return Response(serializer.data, status=status.HTTP_201_CREATED, headers=headers)

class ApprovalChainViewSet(viewsets.ModelViewSet):
    queryset = ApprovalChain.objects.all()
    serializer_class = ApprovalChainSerializer

class ApprovalViewSet(viewsets.ViewSet):
    @action(detail=True, methods=['post'])
    def approve(self, request, pk=None):
        entity_type = request.data.get('entity_type')
        user = CustomUser.objects.get(pk=request.user.id)
        try:
            approval_entity = ApprovalEntity.objects.get(name=entity_type)
            approval = Approval.objects.create(
                entity_id=pk,
                entity_type=approval_entity,
                approved_by=user,
                status=True
            )
            approval.save()
            return Response({'status': 'Approved'}, status=status.HTTP_200_OK)
        except ApprovalEntity.DoesNotExist:
            return Response({'error': 'Invalid entity type'}, status=status.HTTP_400_BAD_REQUEST)

    @action(detail=True, methods=['post'])
    def reject(self, request, pk=None):
        entity_type = request.data.get('entity_type')
        user = CustomUser.objects.get(pk=request.user.id)
        try:
            approval_entity = ApprovalEntity.objects.get(name=entity_type)
            approval = Approval.objects.create(
                entity_id=pk,
                entity_type=approval_entity,
                approved_by=user,
                status=False
            )
            approval.save()
            return Response({'status': 'Rejected'}, status=status.HTTP_200_OK)
        except ApprovalEntity.DoesNotExist:
            return Response({'error': 'Invalid entity type'}, status=status.HTTP_400_BAD_REQUEST)
