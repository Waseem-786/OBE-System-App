from rest_framework.response import Response
from rest_framework import generics, status
from rest_framework.views import APIView
from django.shortcuts import get_object_or_404
from django.contrib.auth.models import Group
from .models import CustomUser
from .serializers import RoleSerializer, UserSerializer
from rest_framework.permissions import IsAdminUser, IsAuthenticated
from rest_framework_simplejwt.authentication import JWTAuthentication

class Roles(generics.ListCreateAPIView):
    queryset = Group.objects.all()
    serializer_class = RoleSerializer
    authentication_classes = [JWTAuthentication]
    pagination_class = [IsAdminUser]
    
class SingleRole(generics.RetrieveUpdateDestroyAPIView):
    queryset = Group.objects.all()
    serializer_class = RoleSerializer
    authentication_classes = [JWTAuthentication]
    pagination_class = [IsAdminUser]


class AddUserToGroupView(APIView):
    permission_classes = [IsAdminUser]
    authentication_classes = [JWTAuthentication]

    def get(self, request, group):
        group = get_object_or_404(Group,name=group)
        if group:
            users_in_group = CustomUser.objects.filter(groups__name=group)
            serialized_data = UserSerializer(users_in_group, many=True)
            return Response(serialized_data.data, status=status.HTTP_200_OK)
        else:
            return Response({"message":f"{group} Group not exist"},status=status.HTTP_400_BAD_REQUEST)

    def post(self, request, group):
        required_fields = ['username']
        if not all(field in request.data for field in required_fields):
            errors = {field: ["This field is required."] for field in required_fields}
            return Response(errors, status=status.HTTP_400_BAD_REQUEST)

        group = get_object_or_404(Group,name=group)
        # Check if the user is already in a group
        user_name = request.data['username']
        user = get_object_or_404(CustomUser, username=user_name)
        
        # Check if the user is already in any group
        if user.groups.exists():
            return Response({"message": f"User {user_name} is already in a group."},
                            status=status.HTTP_400_BAD_REQUEST)

        group = get_object_or_404(Group, name=group)
        group.user_set.add(user)
        group.save()  # Save the group after adding the user

        return Response({"message": f"User added to {group} group"}, status=status.HTTP_201_CREATED)

    def delete(self, request,group):
        required_fields = ['username']
        if not all(field in request.data for field in required_fields):
            errors = {field: ["This field is required."] for field in required_fields}
            return Response(errors, status=status.HTTP_400_BAD_REQUEST)

        user_name = request.data['username']
        user = get_object_or_404(CustomUser, username=user_name)

        # Check if the user is in any group
        if user.groups.exists():
            user.groups.clear()
            return Response({"message": f"User removed from group"}, status=status.HTTP_200_OK)
        else:
            return Response({"message": f"User is not in any group"}, status=status.HTTP_204_NO_CONTENT)
        
    def put(self, request, group):
        required_fields = ['username']
        if not all(field in request.data for field in required_fields):
            errors = {field: ["This field is required."] for field in required_fields}
            return Response(errors, status=status.HTTP_400_BAD_REQUEST)

        group = get_object_or_404(Group,name=group)
        # Check if the user is already in a group
        user_name = request.data['username']
        user = get_object_or_404(CustomUser, username=user_name)
        
        # Check if the user is already in any group
        if user.groups.exists():
            # Remove the user from all groups
            user.groups.clear()
            group = get_object_or_404(Group, name=group)
            group.user_set.add(user)

            group.save()  # Save the group after adding the user
            return Response({"message": f"User {user_name} is now added in {group} group."},
                            status=status.HTTP_200_OK)
        else:
            return Response({"message": f"User not present in any group"}, status=status.HTTP_400_BAD_REQUEST)
