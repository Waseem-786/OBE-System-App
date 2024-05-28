from django.shortcuts import get_object_or_404
from rest_framework import generics, status
from rest_framework.response import Response
from rest_framework_simplejwt.authentication import JWTStatelessUserAuthentication
from user_management.permissions import IsSuper_University_Campus_Department
from .models import PEO, PLO, PEO_PLO_Mapping
from university_management.models import University, Department
from .serializers import PEO_Serializer, PLO_Serializer, PEO_PLO_Mapping_Serializer
from .utils import check_peo_consistency, get_peo_suggestions
from rest_framework.exceptions import APIException

class PEO_View(generics.ListCreateAPIView):
    queryset = PEO.objects.all()
    serializer_class = PEO_Serializer
    # permission_classes = [IsSuper_University_Campus_Department]
    # authentication_classes = [JWTStatelessUserAuthentication]

    def create(self, request, *args, **kwargs):
        serializer = self.get_serializer(data=request.data)
        serializer.is_valid(raise_exception=True)
        
        department_id = serializer.validated_data.get('program').id
        peo_description = serializer.validated_data.get('description')
        
        temp_peo = PEO(description=peo_description, program_id=department_id)
        temp_peo.save()
        
        try:
            inconsistencies = check_peo_consistency(temp_peo.id, department_id)
            
            if not inconsistencies:
                self.perform_create(serializer)
                temp_peo.delete()
                return Response(serializer.data, status=status.HTTP_201_CREATED)
            else:
                department = get_object_or_404(Department, id=department_id)
                campus = department.campus
                university = campus.university
                
                vision_mission_texts = {
                    "University Vision": university.vision,
                    "University Mission": university.mission,
                    "Campus Vision": campus.vision,
                    "Campus Mission": campus.mission,
                    "Department Vision": department.vision,
                    "Department Mission": department.mission
                }
                
                suggestions = get_peo_suggestions(peo_description, vision_mission_texts)
                
                temp_peo.delete()
                return Response({
                    "message": "The PEO is not consistent with the following: " + ", ".join(inconsistencies),
                    "suggestions": suggestions
                }, status=status.HTTP_400_BAD_REQUEST)
        
        except APIException as e:
            temp_peo.delete()
            return Response({"message": str(e)}, status=status.HTTP_400_BAD_REQUEST)


class SinglePEO_View(generics.RetrieveUpdateDestroyAPIView):
    queryset = PEO.objects.all()
    serializer_class = PEO_Serializer
    permission_classes = [IsSuper_University_Campus_Department]
    authentication_classes = [JWTStatelessUserAuthentication]

class PLO_View(generics.ListCreateAPIView):
    queryset = PLO.objects.all()
    serializer_class = PLO_Serializer
    permission_classes = [IsSuper_University_Campus_Department]
    authentication_classes = [JWTStatelessUserAuthentication]

class SinglePLO_View(generics.RetrieveUpdateDestroyAPIView):
    queryset = PLO.objects.all()
    serializer_class = PLO_Serializer
    permission_classes = [IsSuper_University_Campus_Department]
    authentication_classes = [JWTStatelessUserAuthentication]

class PEO_PLO_Mapping_View(generics.ListCreateAPIView):
    queryset = PEO_PLO_Mapping.objects.all()
    serializer_class = PEO_PLO_Mapping_Serializer
    # permission_classes = [IsSuper_University_Campus_Department]
    # authentication_classes = [JWTStatelessUserAuthentication]


class ALL_PEO_For_Specific_Program(generics.ListAPIView):
    serializer_class = PEO_Serializer
    permission_classes = [IsSuper_University_Campus_Department]
    authentication_classes = [JWTStatelessUserAuthentication]

    def get_queryset(self):
        program_id = self.kwargs.get('program_id')
        return PEO.objects.filter(program=program_id)
    
class ALL_PLO_For_Specific_Program(generics.ListAPIView):
    serializer_class = PLO_Serializer
    permission_classes = [IsSuper_University_Campus_Department]
    authentication_classes = [JWTStatelessUserAuthentication]

    def get_queryset(self):
        program_id = self.kwargs.get('program_id')
        return PLO.objects.filter(program=program_id)