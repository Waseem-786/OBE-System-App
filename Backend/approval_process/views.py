from rest_framework import generics
from rest_framework import status
from user_management.models import CustomGroup
from rest_framework.response import Response
from university_management.models import Campus
from .models import CLOUpdateRequest, ApprovalProcess, ApprovalChain, ApprovalChainStep, ApprovalStep
from .serializers import CLOUpdateRequestSerializer, ApprovalProcessSerializer, ApprovalChainSerializer


class ApprovalChainCreateView(generics.CreateAPIView):
    queryset = ApprovalChain.objects.all()
    serializer_class = ApprovalChainSerializer

    def create(self, request, *args, **kwargs):
        data = request.data
        campus_id = data.get('campus_id')
        steps = data.get('steps')

        # Validate input data
        if not campus_id or not steps:
            return Response({"error": "Campus ID, department, and steps are required."}, status=status.HTTP_400_BAD_REQUEST)

        try:
            campus = Campus.objects.get(pk=campus_id)
        except Campus.DoesNotExist:
            return Response({"error": "Campus with the provided ID does not exist."}, status=status.HTTP_404_NOT_FOUND)

        # Create the approval chain
        approval_chain = ApprovalChain.objects.create(campus=campus)

        # Create approval chain steps
        for step_data in steps:
            role_id = step_data.get('role_id')
            step_number = step_data.get('step_number')

            try:
                role = CustomGroup.objects.get(pk=role_id)
            except CustomGroup.DoesNotExist:
                return Response({"error": f"Role with ID {role_id} does not exist."}, status=status.HTTP_404_NOT_FOUND)

            ApprovalChainStep.objects.create(approval_chain=approval_chain, approval_step=ApprovalStep.objects.create(role=role, step_number=step_number), order=step_number)

        serializer = self.get_serializer(approval_chain)
        return Response(serializer.data, status=status.HTTP_201_CREATED)


class CLOUpdateRequestCreateView(generics.CreateAPIView):
    queryset = CLOUpdateRequest.objects.all()
    serializer_class = CLOUpdateRequestSerializer


class ApprovalProcessUpdateView(generics.UpdateAPIView):
    queryset = ApprovalProcess.objects.all()
    serializer_class = ApprovalProcessSerializer

    def update(self, request, *args, **kwargs):
        instance = self.get_object()
        data = request.data

        # Check if the request is for approval or rejection
        action = data.get('action')

        if action not in ['approve', 'reject']:
            return Response({"error": "Invalid action. Action must be 'approve' or 'reject'."}, status=status.HTTP_400_BAD_REQUEST)

        # Update the approval process status and the approved_by field
        if action == 'approve':
            instance.status = 'Approved'
            instance.approved_by = request.user
        elif action == 'reject':
            instance.status = 'Rejected'
            instance.approved_by = request.user

        # Update justification if provided
        justification = data.get('justification')
        if justification:
            instance.justification = justification

        instance.save()

        serializer = self.get_serializer(instance)
        return Response(serializer.data)
    


class ApprovalChainByCampusView(generics.ListAPIView):
    serializer_class = ApprovalChainSerializer

    def get_queryset(self):
        campus_id = self.request.query_params.get('campus_id')

        if not campus_id:
            return ApprovalChain.objects.none()

        try:
            campus = Campus.objects.get(pk=campus_id)
            return ApprovalChain.objects.filter(campus=campus)
        except Campus.DoesNotExist:
            return ApprovalChain.objects.none()

    def list(self, request, *args, **kwargs):
        queryset = self.get_queryset()
        serializer = self.serializer_class(queryset, many=True)
        return Response(serializer.data)