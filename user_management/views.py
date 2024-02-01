from rest_framework import generics

from django.contrib.auth.models import Group
from .serializers import RoleSerializer

class Roles(generics.ListCreateAPIView):
    queryset = Group.objects.all()
    serializer_class = RoleSerializer
    
class SingleRole(generics.RetrieveUpdateDestroyAPIView):
    queryset = Group.objects.all()
    serializer_class = RoleSerializer