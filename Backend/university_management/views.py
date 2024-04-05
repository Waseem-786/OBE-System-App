from rest_framework import generics
from .models import University, Campus, Department, Section, Batch
from .serializers import UniversitySerializer, CampusSerializer, DepartmentSerializer, BatchSerializer, SectionSerializer
from rest_framework_simplejwt.authentication import JWTStatelessUserAuthentication
from user_management.permissions import IsSuperUser, IsUniversityAdmin, IsCampusAdmin, IsDepartmentAdmin, IsSuper_University, IsSuper_University_Campus, IsSuper_University_Campus_Department
# Create your views here.

class UniversityView(generics.ListCreateAPIView):
    queryset = University.objects.all()
    serializer_class = UniversitySerializer
    permission_classes = [IsSuperUser]
    authentication_classes = [JWTStatelessUserAuthentication]

class CampusView(generics.ListCreateAPIView):
    queryset = Campus.objects.all()
    serializer_class = CampusSerializer
    permission_classes = [IsSuper_University]
    authentication_classes = [JWTStatelessUserAuthentication]


class DepartmentView(generics.ListCreateAPIView):
    queryset = Department.objects.all()
    serializer_class = DepartmentSerializer
    permission_classes = [IsSuper_University_Campus]
    authentication_classes = [JWTStatelessUserAuthentication]

class BatchView(generics.ListCreateAPIView):
    queryset = Batch.objects.all()
    serializer_class = BatchSerializer
    authentication_classes = [JWTStatelessUserAuthentication]
    permission_classes = [IsSuper_University_Campus_Department]

class SectionView(generics.ListCreateAPIView):
    queryset = Section.objects.all()
    serializer_class = SectionSerializer
    authentication_classes = [JWTStatelessUserAuthentication]
    permission_classes = [IsSuper_University_Campus_Department]