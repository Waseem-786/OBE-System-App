from django.shortcuts import get_object_or_404
from rest_framework import generics
from rest_framework.decorators import APIView
from rest_framework.response import Response
from rest_framework_simplejwt.authentication import JWTStatelessUserAuthentication
from user_management.permissions import IsSuperUser, IsUniversityAdmin, IsCampusAdmin, IsDepartmentAdmin, IsSuper_University, IsSuper_University_Campus, IsSuper_University_Campus_Department

from .models import PEO, PLO, PEO_PLO_Mapping
from university_management.models import University
from .serializers import PEO_Serializer, PLO_Serializer, PEO_PLO_Mapping_Serializer
from .utils import find_similar_words

# Create your views here.
class PEO_View(generics.ListCreateAPIView):
    queryset = PEO.objects.all()
    serializer_class = PEO_Serializer
    permission_classes = [IsSuper_University_Campus_Department]
    authentication_classes = [JWTStatelessUserAuthentication]

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
    permission_classes = [IsSuper_University_Campus_Department]
    authentication_classes = [JWTStatelessUserAuthentication]


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
    




class VisionStatementMapping(APIView):
    def get(self, request):
        # Assume you have only one university for simplicity
        university = University.objects.get(id=8)
        vision_statement = university.vision
        
        if vision_statement:
            if isinstance(vision_statement, str):
                peos = PEO.objects.filter(program=1)
                peo_keyword_mapping = {}
                for index, peo in enumerate(peos):
                    peo_desc = peo.description
                    vision_statement = """An ability to apply knowledge of mathematics, science, engineering fundamentals and an engineering specialization to the solution of complex engineering problems."""
                    peo_keywords = find_similar_words(vision_statement, peo_desc)
                    peo_keyword_mapping[f'PEO {index + 1}'] = peo_keywords
        
                return Response(peo_keyword_mapping)
            else:
                return Response({"Vision must be a string"})
        return Response({"Vision can't be null"})