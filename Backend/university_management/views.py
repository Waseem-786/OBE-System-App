from django.db import transaction
from django.shortcuts import get_object_or_404
from rest_framework import generics
from rest_framework.response import Response
from rest_framework.views import APIView, status
from .models import University, Campus, Department, Section, Batch, BatchSection
from .serializers import UniversitySerializer, CampusSerializer, DepartmentSerializer, BatchSerializer, SectionSerializer, BatchSectionSerializer
from rest_framework_simplejwt.authentication import JWTStatelessUserAuthentication
from user_management.permissions import IsSuperUser, IsUniversityAdmin, IsCampusAdmin, IsDepartmentAdmin, IsSuper_University, IsSuper_University_Campus, IsSuper_University_Campus_Department
from university_management.permissions import IsUserUniversity, IsUserCampus, IsUserDepartment
# Create your views here.

class UniversityView(generics.ListCreateAPIView):
    queryset = University.objects.all()
    serializer_class = UniversitySerializer
    permission_classes = [IsSuperUser]
    authentication_classes = [JWTStatelessUserAuthentication]

class SingleUniversityView(generics.RetrieveUpdateDestroyAPIView):
    queryset = University.objects.all()
    serializer_class = UniversitySerializer
    permission_classes = [IsUserUniversity]
    authentication_classes = [JWTStatelessUserAuthentication]
    def get_permissions(self):
        if self.request.method == 'DELETE':
            return [IsSuperUser]
        return super().get_permissions()
        
class CampusView(generics.ListCreateAPIView):
    queryset = Campus.objects.all()
    serializer_class = CampusSerializer
    permission_classes = [IsUniversityAdmin]
    authentication_classes = [JWTStatelessUserAuthentication]

class SingleCampusView(generics.RetrieveUpdateDestroyAPIView):
    queryset = Campus.objects.all()
    serializer_class = CampusSerializer
    permission_classes = [IsUserCampus]
    authentication_classes = [JWTStatelessUserAuthentication]
    def get_permissions(self):
        if self.request.method == 'DELETE':
            return [IsUniversityAdmin]
        return super().get_permissions()

class AllCampuses_For_SpecificUniversity_View(generics.ListAPIView):    
    serializer_class = CampusSerializer
    permission_classes = [IsSuper_University_Campus]
    authentication_classes = [JWTStatelessUserAuthentication]
    def get_queryset(self):
        university_id = self.kwargs.get('university_id')
        return Campus.objects.filter(university=university_id)

class DepartmentView(generics.ListCreateAPIView):
    queryset = Department.objects.all()
    serializer_class = DepartmentSerializer
    permission_classes = [IsCampusAdmin]
    authentication_classes = [JWTStatelessUserAuthentication]

class SingleDepartmentView(generics.RetrieveUpdateDestroyAPIView):
    queryset = Department.objects.all()
    serializer_class = DepartmentSerializer
    permission_classes = [IsUserDepartment]
    authentication_classes = [JWTStatelessUserAuthentication]
    def get_permissions(self):
        if self.request.method == 'DELETE':
            return [IsCampusAdmin]
        return super().get_permissions()
    
class AllDepartment_For_SpecificCampus_View(generics.ListAPIView):    
    serializer_class = DepartmentSerializer
    permission_classes = [IsSuper_University_Campus]
    authentication_classes = [JWTStatelessUserAuthentication]
    def get_queryset(self):
        campus_id = self.kwargs.get('campus_id')
        return Department.objects.filter(campus=campus_id)

class BatchView(generics.ListCreateAPIView):
    queryset = Batch.objects.all()
    serializer_class = BatchSerializer
    authentication_classes = [JWTStatelessUserAuthentication]
    permission_classes = [IsDepartmentAdmin]

class SectionView(APIView):
    permission_classes = [IsDepartmentAdmin]
    authentication_classes = [JWTStatelessUserAuthentication]

    def get(self, request, batchId):
        # Query all sections associated with the batch ID
        sections = Section.objects.filter(batchsection__batch_id=batchId)

        if not sections:
            return Response({"error": "No sections found for the given batch ID"}, status=status.HTTP_404_NOT_FOUND)
        # Serialize the sections data
        serializer = SectionSerializer(sections, many=True)
        
        # Return the serialized data as the API response
        return Response(serializer.data, status=status.HTTP_200_OK)
    
    def post(self, request, batchId):
        if 'name' not in request.data:
            return Response({"name": "This field is required"}, status=status.HTTP_400_BAD_REQUEST)
        
        section_name = request.data['name']
        batch = get_object_or_404(Batch, id=batchId)
        
        try:
            with transaction.atomic():
                section, created = Section.objects.get_or_create(name=section_name)
                
                # Check if the section was already created
                if not created:
                    # Check if the section is already associated with the batch
                    if BatchSection.objects.filter(batch=batch, section=section).exists():
                        return Response({"message": "Section already exists for this Batch"}, status=status.HTTP_200_OK)
                
                # Create BatchSection object to map the section with the batch
                batch = BatchSection.objects.create(batch=batch, section=section)
                # Serialize the data
                serialized_data = BatchSectionSerializer(batch)
                if serialized_data.is_valid():
                    serialized_data.save()
                    return Response(serialized_data.data, status=status.HTTP_201_CREATED)
                return Response(serialized_data.errors, status=status.HTTP_400_BAD_REQUEST)

        except Exception as e:
            # If an error occurs during section creation or batch-section association, rollback the transaction
            return Response({"error": "Failed to create section"}, status=status.HTTP_500_INTERNAL_SERVER_ERROR)

class SingleBatchView(generics.RetrieveUpdateDestroyAPIView):
    queryset = Batch.objects.all()
    serializer_class = BatchSerializer
    permission_classes = [IsDepartmentAdmin]
    authentication_classes = [JWTStatelessUserAuthentication]
    def get_permissions(self):
        if self.request.method == 'PATCH' or self.request.method == 'PUT':
            return [IsUserDepartment]
        return super().get_permissions()
    
class SingleSectionView(generics.RetrieveUpdateDestroyAPIView):
    queryset = Section.objects.all()
    serializer_class = BatchSectionSerializer
    permission_classes = [IsDepartmentAdmin]
    authentication_classes = [JWTStatelessUserAuthentication]