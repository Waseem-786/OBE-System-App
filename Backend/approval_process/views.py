# from django.shortcuts import get_object_or_404
# from rest_framework import generics, status
# from rest_framework.response import Response
# from user_management.permissions import IsUniversityAdmin
# from rest_framework_simplejwt.authentication import JWTStatelessUserAuthentication
# from .models import EntityType, ApprovalRequest
# from .serializers import EntityTypeSerializer, ApprovalRequestSerializer

# class EntityTypeListView(generics.CreateAPIView):
#     queryset = EntityType.objects.all()
#     serializer_class = EntityTypeSerializer

# class EntityTypeListView(generics.ListAPIView):
#     queryset = EntityType.objects.all()
#     serializer_class = EntityTypeSerializer

# class ApprovalRequestListView(generics.CreateAPIView):
#     serializer_class = ApprovalRequestSerializer

#     def get_queryset(self):
#         # Filter by user permissions or other criteria if needed
#         return ApprovalRequest.objects.all()

# class ApprovalRequestListView(generics.ListAPIView):
#     serializer_class = ApprovalRequestSerializer

#     def get_queryset(self):
#         # Filter by user permissions or other criteria if needed
#         return ApprovalRequest.objects.all()

# class ApprovalRequestDetailView(generics.RetrieveAPIView):
#     serializer_class = ApprovalRequestSerializer

#     def get_object(self):
#         pk = self.kwargs['pk']
#         return get_object_or_404(ApprovalRequest, pk=pk)

# # Additional views for CRUD operations on ApprovalGroup (not shown here)
# # can be implemented using generics.CreateAPIView, generics.UpdateAPIView, etc.
