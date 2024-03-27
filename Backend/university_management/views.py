from rest_framework import generics
from .models import University, Campus, Department, Section, Batch
from .serializers import UniversitySerializer, CampusSerializer
from rest_framework.permissions import IsAdminUser
from rest_framework_simplejwt.authentication import JWTStatelessUserAuthentication
from user_management.permissions import IsSuperUser
# Create your views here.

class UniversityView(generics.ListCreateAPIView):
    queryset = University.objects.all()
    serializer_class = UniversitySerializer
    permission_classes = [IsSuperUser]
    authentication_classes = [JWTStatelessUserAuthentication]

class CampusView(generics.ListCreateAPIView):
    queryset = Campus.objects.all()
    serializer_class = CampusSerializer
    permission_classes = [IsSuperUser]
    authentication_classes = [JWTStatelessUserAuthentication]