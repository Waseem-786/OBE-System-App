from django.db import transaction
from django.shortcuts import get_object_or_404
from rest_framework import generics
from rest_framework.response import Response
from rest_framework.views import APIView, status
from .models import University, Campus, Department, Section, Batch
from .serializers import UniversitySerializer, CampusSerializer, DepartmentSerializer, BatchSerializer, SectionSerializer
from rest_framework_simplejwt.authentication import JWTStatelessUserAuthentication
from user_management.permissions import IsSuperUser, IsUniversityAdmin, IsCampusAdmin, IsDepartmentAdmin, IsSuper_University, IsSuper_University_Campus, IsSuper_University_Campus_Department
from university_management.permissions import IsUserUniversity, IsUserCampus, IsUserDepartment
# Create your views here.

class UniversityView(generics.ListCreateAPIView):
    queryset = University.objects.all()
    serializer_class = UniversitySerializer
    permission_classes = [IsSuper_University_Campus_Department]
    authentication_classes = [JWTStatelessUserAuthentication]

class SingleUniversityView(generics.RetrieveUpdateDestroyAPIView):
    queryset = University.objects.all()
    serializer_class = UniversitySerializer
    permission_classes = [IsSuper_University_Campus_Department]
    authentication_classes = [JWTStatelessUserAuthentication]
    # def get_permissions(self):
    #     if self.request.method == 'DELETE':
    #         return [IsSuperUser]
    #     return super().get_permissions()
        
class CampusView(generics.ListCreateAPIView):
    queryset = Campus.objects.all()
    serializer_class = CampusSerializer
    permission_classes = [IsSuper_University_Campus_Department]
    authentication_classes = [JWTStatelessUserAuthentication]

class SingleCampusView(generics.RetrieveUpdateDestroyAPIView):
    queryset = Campus.objects.all()
    serializer_class = CampusSerializer
    permission_classes = [IsSuper_University_Campus_Department]
    authentication_classes = [JWTStatelessUserAuthentication]
    # def get_permissions(self):
    #     if self.request.method == 'DELETE':
    #         return [IsUniversityAdmin]
    #     return super().get_permissions()

class AllCampuses_For_SpecificUniversity_View(generics.ListAPIView):    
    serializer_class = CampusSerializer
    permission_classes = [IsSuper_University_Campus_Department]
    authentication_classes = [JWTStatelessUserAuthentication]
    def get_queryset(self):
        university_id = self.kwargs.get('university_id')
        return Campus.objects.filter(university=university_id)

class DepartmentView(generics.ListCreateAPIView):
    queryset = Department.objects.all()
    serializer_class = DepartmentSerializer
    permission_classes = [IsSuper_University_Campus_Department]
    authentication_classes = [JWTStatelessUserAuthentication]

class SingleDepartmentView(generics.RetrieveUpdateDestroyAPIView):
    queryset = Department.objects.all()
    serializer_class = DepartmentSerializer
    permission_classes = [IsSuper_University_Campus_Department]
    authentication_classes = [JWTStatelessUserAuthentication]
    # def get_permissions(self):
    #     if self.request.method == 'DELETE':
    #         return [IsCampusAdmin]
    #     return super().get_permissions()
    
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
    permission_classes = [IsSuper_University_Campus_Department]

    def perform_create(self, serializer):
        sections_data = serializer.validated_data.get('sections', [])  # Get sections data from request
        batch_instance = serializer.save()  # Save the batch instance

        for section_name in sections_data:
            section_instance, _ = Section.objects.get_or_create(name=section_name)  # Get or create section

            # Check if the section is already associated with the batch
            if batch_instance.sections.filter(name=section_name).exists():
                return Response({"error": f"Section '{section_name}' is already associated with this batch."},
                                status=status.HTTP_400_BAD_REQUEST)
            
            batch_instance.sections.add(section_instance)  # Add section to batch

class SingleBatchView(generics.RetrieveUpdateDestroyAPIView):
    queryset = Batch.objects.all()
    serializer_class = BatchSerializer
    permission_classes = [IsSuper_University_Campus_Department]
    authentication_classes = [JWTStatelessUserAuthentication]
    
    def perform_update(self, serializer):
        sections_data = serializer.validated_data.get('sections', [])  # Get sections data from request
        batch_instance = serializer.save()  # Save the batch instance
        batch_sections = batch_instance.sections.all()  # Get all sections associated with the batch

        # Remove sections that are no longer included in the request
        for section in batch_sections:
            if section.name not in sections_data:
                batch_instance.sections.remove(section)

        # Add new sections from the request
        for section_name in sections_data:
            section_instance, _ = Section.objects.get_or_create(name=section_name)  # Get or create section
            batch_instance.sections.add(section_instance)  # Add section to batch

class Batch_of_SpecificDepartment(generics.ListAPIView):
    serializer_class = BatchSerializer
    permission_classes = [IsSuper_University_Campus_Department]
    authentication_classes = [JWTStatelessUserAuthentication]
    def get_queryset(self):
        deparmtnet_id = self.kwargs['department_id']
        queryset = Batch.objects.filter(department__id=deparmtnet_id)
        return queryset

class AllSections_of_SpecificBatch_View(generics.ListAPIView):
    serializer_class = SectionSerializer
    permission_classes = [IsSuper_University_Campus_Department]
    authentication_classes = [JWTStatelessUserAuthentication]

    def get_queryset(self):
        batch_id = self.kwargs['pk']
        batch = get_object_or_404(Batch, id=batch_id)
        return batch.sections.all()

class CreateSectionView(APIView):
    permission_classes = [IsSuper_University_Campus_Department]
    authentication_classes = [JWTStatelessUserAuthentication]

    def post(self, request):
        batch_id = request.data.get('batch')
        section_name = request.data.get('name')

        batch = get_object_or_404(Batch, id=batch_id)

        # Get or create the section
        section_instance, _ = Section.objects.get_or_create(name=section_name)

        # Check if the section is already associated with the batch
        if section_instance in batch.sections.all():
            return Response({"error": f"Section '{section_name}' is already associated with this batch."},
                            status=status.HTTP_400_BAD_REQUEST)
        
        batch.sections.add(section_instance)  # Add section to batch

        return Response({"message": f"Section '{section_name}' has been successfully associated with the batch."},
                        status=status.HTTP_201_CREATED)
    

class SingleSectionView(generics.RetrieveUpdateDestroyAPIView):
    queryset = Section.objects.all()
    serializer_class = SectionSerializer
    permission_classes = [IsSuper_University_Campus_Department]
    authentication_classes = [JWTStatelessUserAuthentication]
    
