from django.shortcuts import get_object_or_404
from rest_framework import generics
from rest_framework_simplejwt.authentication import JWTStatelessUserAuthentication
from user_management.permissions import IsSuperUser, IsUniversityAdmin, IsCampusAdmin, IsDepartmentAdmin, IsSuper_University, IsSuper_University_Campus, IsSuper_University_Campus_Department

from .models import PEO, PLO, PEO_PLO_Mapping
from .serializers import PEO_Serializer, PLO_Serializer, PEO_PLO_Mapping_Serializer
# Create your views here.

class PEO_View(generics.ListCreateAPIView):
    queryset = PEO.objects.all()
    serializer_class = PEO_Serializer
    permission_classes = [IsSuper_University_Campus]
    authentication_classes = [JWTStatelessUserAuthentication]

class PLO_View(generics.ListCreateAPIView):
    queryset = PLO.objects.all()
    serializer_class = PLO_Serializer
    permission_classes = [IsSuper_University_Campus]
    authentication_classes = [JWTStatelessUserAuthentication]

class PEO_PLO_Mapping_View(generics.ListCreateAPIView):
    queryset = PEO_PLO_Mapping.objects.all()
    serializer_class = PEO_PLO_Mapping_Serializer
    permission_classes = [IsSuper_University_Campus]
    authentication_classes = [JWTStatelessUserAuthentication]