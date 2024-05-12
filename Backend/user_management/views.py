from rest_framework.response import Response
from rest_framework import generics, status
from rest_framework.views import APIView
from django.shortcuts import get_object_or_404
from django.contrib.auth.models import Permission
from .models import CustomUser, CustomGroup
from django.contrib.auth.models import Group
from university_management.models import University, Campus, Department
from .serializers import RoleSerializer, CustomUserSerializer, PermissionsSerializer, UserSerializer, GroupSerializer
from .permissions import IsSuperUser, IsUniversityAdmin, IsCampusAdmin, IsDepartmentAdmin, IsSuper_University_Campus, IsSuper_University, IsSuper_University_Campus_Department
from rest_framework_simplejwt.authentication import JWTStatelessUserAuthentication

# Create & Get All Top Level Roles
class TopLevelRoles(APIView):
    permission_classes = [IsSuperUser]
    authentication_classes = [JWTStatelessUserAuthentication]

    def get(self, request):
        roles = CustomGroup.objects.filter(
            university__id=0,
            campus__id=0,
            department__id=0,
        )
        serialized_data = RoleSerializer(roles, many=True)
        return Response(serialized_data.data,status=status.HTTP_200_OK)

    def post(self, request):
        required_fields = ['name']
        errors = {}
        if not all(field in request.data for field in required_fields):
            errors = {field: ["This field is required."] for field in required_fields}
            return Response(errors,status=status.HTTP_400_BAD_REQUEST)

        role_name = request.data['name']

        # Check if the group already exists. If it isn't it will create else nothing. 
        group, created = Group.objects.get_or_create(name=role_name)
        
        # If the group was created, create a new CustomGroup instance
        custom_group, mapped = CustomGroup.objects.get_or_create(group=group)
        
        if mapped:
            # Serialize the data
            serialized_data = RoleSerializer(custom_group)
            # Return the serialized data in the response
            return Response(serialized_data.data, status=status.HTTP_201_CREATED)
        else:
            # If the group already exists and mapped, return an appropriate response
            return Response({'message': 'Role already exists'}, status=status.HTTP_200_OK)
        
# Create & Get All University Level Roles
class UniversityLevelRoles(APIView):
    authentication_classes = [JWTStatelessUserAuthentication]
    permission_classes = [IsUniversityAdmin]

    def get(self, request,university_id):
        university = get_object_or_404(University,id=university_id)
        roles = CustomGroup.objects.filter(
            university__id=university.id,
            campus__id=0,
            department__id=0,
        )

        serialized_data = RoleSerializer(roles, many=True)
        return Response(serialized_data.data, status=status.HTTP_200_OK)
    
    def post(self, request, university_id):
        university = get_object_or_404(University, id=university_id)
        required_fields = ['name']
        if not all(field in request.data for field in required_fields):
            errors = {field: ['This field is required'] for field in required_fields}
            return Response(errors, status=status.HTTP_400_BAD_REQUEST)

        role_name = request.data['name']
        
        # Retrieve the CustomUser instance. So that we can restrict user that specific user can only add role in his/her university. NUST user can't add role in FAST university.
        get_object_or_404(CustomUser, id=request.user.id, university=university)
        
        # Check if the group already exists. If it isn't it will create else nothing. 
        group, created = Group.objects.get_or_create(name=role_name)
        
        # If the group was created, create a new CustomGroup instance
        custom_group, mapped = CustomGroup.objects.get_or_create(group=group, university=university)
        
        if mapped:
            # Serialize the data
            serialized_data = RoleSerializer(custom_group)
        
            # Return the serialized data in the response
            return Response(serialized_data.data, status=status.HTTP_201_CREATED)
        else:
            # If the group already exists and mapped, return an appropriate response
            return Response({'message': 'Role already exists'}, status=status.HTTP_200_OK)
    
# Create & Get All Campus Level Roles
class CampusLevelRoles(APIView):
    authentication_classes = [JWTStatelessUserAuthentication]
    permission_classes = [IsCampusAdmin]

    def get(self, request, campus_id):
        campus = get_object_or_404(Campus, id=campus_id)
        roles = CustomGroup.objects.filter(
            campus__id=campus.id,
            department__id=0,
        )

        serialized_data = RoleSerializer(roles, many=True)
        return Response(serialized_data.data, status=status.HTTP_200_OK)

    def post(self, request, campus_id):
        campus = get_object_or_404(Campus, id=campus_id)
        required_fields = ['name']
        if not all(field in request.data for field in required_fields):
            errors = {field: ['This field is required'] for field in required_fields}
            return Response(errors, status=status.HTTP_400_BAD_REQUEST)

        role_name = request.data['name']

        # Check if the group already exists. If it isn't, it will create it; otherwise, do nothing.
        group, created = Group.objects.get_or_create(name=role_name)

        # If the group was created, create a new CustomGroup instance
        custom_group, mapped = CustomGroup.objects.get_or_create(group=group, campus=campus)

        if mapped:
            # Serialize the data
            serialized_data = RoleSerializer(custom_group)

            # Return the serialized data in the response
            return Response(serialized_data.data, status=status.HTTP_201_CREATED)
        else:
            # If the group already exists and mapped, return an appropriate response
            return Response({'message': 'Role already exists'}, status=status.HTTP_200_OK)

# Create & Get All Department Level Roles
class DepartmentLevelRoles(APIView):
    authentication_classes = [JWTStatelessUserAuthentication]
    permission_classes = [IsDepartmentAdmin]

    def get(self, request, department_id):
        department = get_object_or_404(Department, id=department_id)
        roles = CustomGroup.objects.filter(department=department)

        serialized_data = RoleSerializer(roles, many=True)
        return Response(serialized_data.data, status=status.HTTP_200_OK)
    
    def post(self, request, department_id):
        department = get_object_or_404(Department, id=department_id)
        required_fields = ['name']
        if not all(field in request.data for field in required_fields):
            errors = {field: ['This field is required'] for field in required_fields}
            return Response(errors, status=status.HTTP_400_BAD_REQUEST)

        role_name = request.data['name']
        
        # You might want to add additional validation here if necessary
        
        # Check if the group already exists. If it isn't, it will create it; otherwise, do nothing.
        group, created = Group.objects.get_or_create(name=role_name)
        
        # If the group was created, create a new CustomGroup instance
        custom_group, mapped = CustomGroup.objects.get_or_create(group=group, department=department)
        
        if mapped:
            # Serialize the data
            serialized_data = RoleSerializer(custom_group)
        
            # Return the serialized data in the response
            return Response(serialized_data.data, status=status.HTTP_201_CREATED)
        else:
            # If the group already exists and mapped, return an appropriate response
            return Response({'message': 'Role already exists'}, status=status.HTTP_200_OK)


# Get Single Role Data, Update & Delete Single Role
class SingleRole(generics.RetrieveUpdateDestroyAPIView):
    permission_classes = [IsSuper_University_Campus_Department]
    authentication_classes = [JWTStatelessUserAuthentication]
    serializer_class = RoleSerializer
    queryset = CustomGroup.objects.all()


# Get all Users & Assign User to a Specific Group
class GroupUsersView(APIView):
    authentication_classes = [JWTStatelessUserAuthentication]
    permission_classes = [IsSuper_University_Campus_Department]

    def get(self, request, group_id):
        # Retrieve the group object based on the provided group_id
        group = get_object_or_404(CustomGroup, id=group_id)
        users = group.user.all()
        serialized_data = UserSerializer(users,many=True)
        return Response(serialized_data.data,status=status.HTTP_200_OK)
    
    def post(self, request, group_id):
        # Check if 'usernames' is present in the request data
        if 'usernames' in request.data:
            usernames = request.data['usernames']
            users_added = []

            # Iterate through the list of usernames
            for username in usernames:
                user = get_object_or_404(CustomUser, username=username)
                
                # Check if the group exists in CustomGroup for the specified group_id
                custom_group = get_object_or_404(CustomGroup, id=group_id)

                if user in custom_group.user.all():
                    # If the user is already in the group, skip and continue to the next user
                    continue
                else:
                    # Add the user to the group
                    custom_group.user.add(user)
                    users_added.append(username)

            if users_added:
                return Response({"message": f"Users {', '.join(users_added)} added to the {custom_group.group.name}"}, status=status.HTTP_201_CREATED)
            else:
                return Response({"message": "No new users added to the group"}, status=status.HTTP_200_OK)
        else:
            # If 'usernames' is not present in the request data, return appropriate response
            return Response({"usernames": "This field is required as a list of usernames"}, status=status.HTTP_400_BAD_REQUEST)


class UserGroupsView(APIView):
    authentication_classes = [JWTStatelessUserAuthentication]
    permission_classes = [IsSuper_University_Campus_Department]

    def get(self, request, user_id):
        # Retrieve the user object based on the provided user_id
        user = get_object_or_404(CustomUser, id=user_id)

        # Get all custom groups associated with the user
        user_groups = user.custom_groups.all()

        # Serialize the groups data
        serialized_data = GroupSerializer(user_groups, many=True)

        return Response(serialized_data.data, status=status.HTTP_200_OK)
    
# Get All Users
class AllUsers(generics.ListAPIView):
    queryset = CustomUser.objects.all()
    serializer_class = CustomUserSerializer
    authentication_classes = [JWTStatelessUserAuthentication]
    permission_classes = [IsSuperUser]


# Get All Users for Specific University
class AllUsers_for_SpecificUniversity(generics.ListAPIView):
    serializer_class = CustomUserSerializer
    authentication_classes = [JWTStatelessUserAuthentication]
    permission_classes = [IsSuper_University]
    def get_queryset(self):
        university_id = self.kwargs('university_id')
        queryset = CustomUser.objects.filter(university=university_id)
        return queryset

# Get All Users for Specific University
class AllUsers_for_SpecificCampus(generics.ListAPIView):
    serializer_class = CustomUserSerializer
    authentication_classes = [JWTStatelessUserAuthentication]
    permission_classes = [IsSuper_University]
    def get_queryset(self):
        campus_id = self.kwargs('campus_id')
        queryset = CustomUser.objects.filter(campus=campus_id)
        return queryset
    
    # Get All Users for Specific University
class AllUsers_for_SpecificDepartment(generics.ListAPIView):
    serializer_class = CustomUserSerializer
    authentication_classes = [JWTStatelessUserAuthentication]
    permission_classes = [IsSuper_University]
    def get_queryset(self):
        department_id = self.kwargs('department_id')
        queryset = CustomUser.objects.filter(department=department_id)
        return queryset# Get All Users for Specific University
    
class PermissionsView(generics.ListAPIView):
    queryset = Permission.objects.all()
    serializer_class = PermissionsSerializer
    authentication_classes = [JWTStatelessUserAuthentication]
    permission_classes = [IsSuper_University_Campus_Department]

class GroupPermissionsView(APIView):
    authentication_classes = [JWTStatelessUserAuthentication]
    permission_classes = [IsSuper_University_Campus_Department]

    def get(self, request, group_id):
        # Retrieve the group object based on the provided group_id
        group = get_object_or_404(CustomGroup, id=group_id)
        
        # Access the permissions associated with the group
        permissions = group.group.permissions.all().order_by('id')

        # Serialize the permissions data if needed
        serialized_data = PermissionsSerializer(permissions, many=True)

        return Response(serialized_data.data, status=status.HTTP_200_OK)

    def post(self, request, group_id):
        if 'permissions' in request.data:
            # Retrieve the permissions data from the request
            permission_ids = request.data.get('permissions', [])

            # Ensure that permission_ids is a list
            if not isinstance(permission_ids, list):
                return Response({"permissions": "Invalid permissions data"}, status=status.HTTP_400_BAD_REQUEST)

            # Retrieve the group object based on the provided group_id
            group = get_object_or_404(CustomGroup, id=group_id)
            
            # Get the count of permissions already associated with the group
            existing_permissions_count = group.group.permissions.filter(id__in=permission_ids).count()

            # Check if any of the provided permissions are already associated with the group
            if existing_permissions_count > 0:
                return Response({"message": "One or more permissions are already associated with the group"}, status=status.HTTP_400_BAD_REQUEST)

            # Add permissions to the group
            for permission_id in permission_ids:
                # Ensure that permission_id is a valid integer
                if not isinstance(permission_id, int):
                    return Response({"permissions": "Invalid permission ID"}, status=status.HTTP_400_BAD_REQUEST)
                
                permission = get_object_or_404(Permission, id=permission_id)
                group.group.permissions.add(permission)

            return Response({"message": "Permissions added successfully"}, status=status.HTTP_201_CREATED)
        
        else:
            # If 'permissions' is not present in the request data, return appropriate response
            return Response({"permissions": "This field is required"}, status=status.HTTP_400_BAD_REQUEST)
        
    
class UserPermissionsView(APIView):
    authentication_classes = [JWTStatelessUserAuthentication]
    permission_classes = [IsSuper_University_Campus_Department]

    def get(self, request, user_id):
        # Retrieve the user object based on the provided user_id
        user = get_object_or_404(CustomUser, id=user_id)
        # Get all custom groups associated with the user
        user_groups = user.custom_groups.all()

        # Initialize a set to hold all permissions
        all_permissions = set()

        # Loop through each group and get permissions associated with it
        for group in user_groups:
            permissions = group.group.permissions.all()
            all_permissions.update(permissions)

        # Serialize the permissions data if needed
        # Assuming you have a serializer for Permission model
        # Replace PermissionsSerializer with your actual serializer
        serialized_data = PermissionsSerializer(all_permissions, many=True)

        return Response(serialized_data.data, status=status.HTTP_200_OK)