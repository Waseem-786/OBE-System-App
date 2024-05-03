from rest_framework import generics, status
from rest_framework.response import Response
from .models import ChainOfCommand, ChainOfCommandUser
from user_management.permissions import IsUniversityAdmin
from rest_framework_simplejwt.authentication import JWTStatelessUserAuthentication
from .serializers import ChainOfCommand_Serializer, ChainOfCommandUserSerializer

class ChainOfCommandCreateView(generics.CreateAPIView):
    queryset = ChainOfCommand.objects.all()
    serializer_class = ChainOfCommand_Serializer
    # permission_classes = [IsUniversityAdmin]
    # authentication_classes = [JWTStatelessUserAuthentication]

    def create(self, request, *args, **kwargs):
        serializer = self.get_serializer(data=request.data)
        print(serializer)
        if not serializer.is_valid():
            return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)
        
        instance = serializer.save()
        users_data = request.data.get('users', [])
        if not isinstance(users_data, list):
            return Response({"message": "Invalid data format for 'users'"}, status=status.HTTP_400_BAD_REQUEST)
        
        for data in users_data:
            user_id = data.get('user_id')
            order = data.get('order')
            if user_id is None or order is None:
                return Response({"message": "Each user must have 'user' and 'order' fields"}, status=status.HTTP_400_BAD_REQUEST)
            # Create a dictionary containing the user ID for serialization
            user_data = {'user_id': user_id, 'order': order}
            # Pass the user data dictionary to the serializer
            user_serializer = ChainOfCommandUserSerializer(data=user_data)
            if not user_serializer.is_valid():
                return Response(user_serializer.errors, status=status.HTTP_400_BAD_REQUEST)
            # Save the user instance
            user_instance = user_serializer.save(chain_of_command=instance)
        
        return Response(ChainOfCommand_Serializer(instance).data, status=status.HTTP_201_CREATED)

class ChainOfCommandDetailView(generics.RetrieveAPIView):
    queryset = ChainOfCommand.objects.all()
    serializer_class = ChainOfCommand_Serializer
    permission_classes = [IsUniversityAdmin]
    authentication_classes = [JWTStatelessUserAuthentication]
