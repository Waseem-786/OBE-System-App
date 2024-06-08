from rest_framework import generics, status
from rest_framework.views import APIView, Response
from .models import ApprovalProcess, ApprovalStep, ApprovalLog
from .serializers import ApprovalProcessSerializer, ApprovalLogSerializer
from django.shortcuts import get_object_or_404
from user_management.models import CustomUser

class ApprovalProcessCreateView(generics.CreateAPIView):
    queryset = ApprovalProcess.objects.all()
    serializer_class = ApprovalProcessSerializer

class ApprovalProcessDetailView(generics.RetrieveUpdateAPIView):
    queryset = ApprovalProcess.objects.all()
    serializer_class = ApprovalProcessSerializer

class ApprovalProcessActionView(APIView):
    def post(self, request, pk, action):
        process = get_object_or_404(ApprovalProcess, pk=pk)
        user = request.user

        if process.status != 'pending':
            return Response({"detail": "This process is already completed."}, status=status.HTTP_400_BAD_REQUEST)

        if process.current_step is None:
            step = ApprovalStep.objects.filter(order=1).first()
        else:
            step = process.current_step

        if not step.group.user_set.filter(id=user.id).exists():
            return Response({"detail": "You are not authorized to perform this action."}, status=status.HTTP_403_FORBIDDEN)

        log = ApprovalLog.objects.create(
            process=process,
            step=step,
            user=user,
            status=action,
            comment=request.data.get('comment', '')
        )

        if action == 'approved':
            next_step = ApprovalStep.objects.filter(order=step.order + 1).first()
            if next_step:
                process.current_step = next_step
            else:
                process.status = 'approved'
                process.current_step = None
        elif action == 'rejected':
            process.status = 'rejected'
            process.current_step = None

        process.save()

        return Response(ApprovalProcessSerializer(process).data)
