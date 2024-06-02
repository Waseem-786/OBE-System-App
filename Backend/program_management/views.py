from django.shortcuts import get_object_or_404
from rest_framework.views import APIView
from rest_framework import generics, status
from rest_framework.response import Response
from rest_framework_simplejwt.authentication import JWTStatelessUserAuthentication
from user_management.permissions import IsSuper_University_Campus_Department
from .models import PEO, PLO, PEO_PLO_Mapping
from university_management.models import University, Department
from .serializers import PEO_Serializer, PLO_Serializer, PEO_PLO_Mapping_Serializer
from .utils import generate_peos, check_peo_consistency


class PEO_View(generics.ListCreateAPIView):
    queryset = PEO.objects.all()
    serializer_class = PEO_Serializer
    # permission_classes = [IsSuper_University_Campus_Department]
    # authentication_classes = [JWTStatelessUserAuthentication]

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




class GeneratePEOView(APIView):
    permission_classes = [JWTStatelessUserAuthentication]  # Adjust permissions as needed

    def post(self, request, department_id):
        num_peos = request.data.get('num_peos', 3)  # Default to generating 3 PEOs if not specified
        additional_message = request.data.get('additional_message', '')

        if not isinstance(num_peos, int) or num_peos <= 0:
            return Response({"error": "Number of PEOs must be a positive integer."}, status=400)
        
        result = generate_peos(department_id, num_peos, additional_message)
        if result['status'] == 'success':
            return Response({"peos": result['peos']}, status=200)
        else:
            return Response({"error": result['message']}, status=400)


class PEOConsistencyView(APIView):
    """
    API view to check the consistency of PEOs with the vision and mission of a department and its related entities.
    """
    permission_classes = [JWTStatelessUserAuthentication]  # Adjust permissions as needed

    def get(self, request, department_id):
        # Call the consistency check function
        results = check_peo_consistency(department_id)
        if 'error' in results:
            return Response({"error": results["error"]}, status=404)
        return Response(results, status=200)