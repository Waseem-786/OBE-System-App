from rest_framework.response import Response
from rest_framework import generics, status
from rest_framework.views import APIView
from django.shortcuts import get_object_or_404
from django.contrib.auth.models import Permission, Group
from .models import CustomUser, CustomGroup
from university_management.models import University, Campus, Department
from .serializers import RoleSerializer, CustomUserSerializer, PermissionsSerializer, UserSerializer, GroupSerializer
from .permissions import IsSuperUser, IsSuper_University, IsSuper_University_Campus_Department
from rest_framework_simplejwt.authentication import JWTStatelessUserAuthentication
from django.db import transaction  # Import transaction
from django.db.models import Q


class TopLevelRoles(APIView):
    permission_classes = [IsSuperUser]
    authentication_classes = [JWTStatelessUserAuthentication]

    def get(self, request):
        roles = CustomGroup.objects.filter(
            Q(university__isnull=True) | Q(university=0),
            Q(campus__isnull=True) | Q(campus=0),
            Q(department__isnull=True) | Q(department=0)
        ).order_by('id')

        serialized_data = RoleSerializer(roles, many=True)
        return Response(serialized_data.data, status=status.HTTP_200_OK)

    @transaction.atomic  # Ensure this method is atomic
    def post(self, request):
        request.data['university'] = None
        request.data['campus'] = None
        request.data['department'] = None
        serializer = RoleSerializer(data=request.data)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data, status=status.HTTP_201_CREATED)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

class UniversityLevelRoles(APIView):
    # authentication_classes = [JWTStatelessUserAuthentication]
    # permission_classes = [IsUniversityAdmin]

    def get(self, request, university_id):
        university = get_object_or_404(University, id=university_id)
        roles = CustomGroup.objects.filter(
            Q(university=university),
            Q(campus__isnull=True) | Q(campus=0),
            Q(department__isnull=True) | Q(department=0)
        ).order_by('id')

        serialized_data = RoleSerializer(roles, many=True)
        return Response(serialized_data.data, status=status.HTTP_200_OK)

    @transaction.atomic  # Ensure this method is atomic
    def post(self, request, university_id):
        university = get_object_or_404(University, id=university_id)
        request.data['university'] = university.id
        request.data['campus'] = None
        request.data['department'] = None
        serializer = RoleSerializer(data=request.data)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data, status=status.HTTP_201_CREATED)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

class CampusLevelRoles(APIView):
    authentication_classes = [JWTStatelessUserAuthentication]
    permission_classes = [IsSuper_University_Campus_Department]

    def get(self, request, campus_id):
        campus = get_object_or_404(Campus, id=campus_id)
        roles = CustomGroup.objects.filter(
            Q(campus=campus),
            Q(department__isnull=True) | Q(department=0)
        ).order_by('id')

        serialized_data = RoleSerializer(roles, many=True)
        return Response(serialized_data.data, status=status.HTTP_200_OK)

    @transaction.atomic  # Ensure this method is atomic
    def post(self, request, campus_id):
        campus = get_object_or_404(Campus, id=campus_id)
        request.data['campus'] = campus.id
        request.data['university'] = campus.university.id
        request.data['department'] = None
        serializer = RoleSerializer(data=request.data)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data, status=status.HTTP_201_CREATED)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

class DepartmentLevelRoles(APIView):
    authentication_classes = [JWTStatelessUserAuthentication]
    permission_classes = [IsSuper_University_Campus_Department]

    def get(self, request, department_id):
        department = get_object_or_404(Department, id=department_id)
        roles = CustomGroup.objects.filter(department=department).order_by('id')

        serialized_data = RoleSerializer(roles, many=True)
        return Response(serialized_data.data, status=status.HTTP_200_OK)

    @transaction.atomic  # Ensure this method is atomic
    def post(self, request, department_id):
        department = get_object_or_404(Department, id=department_id)
        campus = get_object_or_404(Campus, id=department.campus.id)
        university = get_object_or_404(University, id=campus.university.id)
        request.data['department'] = department.id
        request.data['campus'] = campus.id
        request.data['university'] = university.id
        serializer = RoleSerializer(data=request.data)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data, status=status.HTTP_201_CREATED)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

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
        # Check if 'user_ids' is present in the request data
        user_ids = request.data.get('user_ids')
        if not user_ids:
            return Response({"user_ids": "This field is required as a list of user IDs"}, status=status.HTTP_400_BAD_REQUEST)
        
        # Retrieve the custom group
        custom_group = get_object_or_404(CustomGroup, id=group_id)
        
        users_added = []
        for user_id in user_ids:
            user = get_object_or_404(CustomUser, id=user_id)
            if not custom_group.user.filter(id=user_id).exists():
                custom_group.user.add(user)
                users_added.append(user.username)

        if users_added:
            return Response({"message": f"Users {', '.join(users_added)} added to the {custom_group.group.name}"}, status=status.HTTP_201_CREATED)
        else:
            return Response({"message": "No new users added to the group"}, status=status.HTTP_200_OK)


# All Groups of Specific User
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
        university_id = self.kwargs['university_id']
        queryset = CustomUser.objects.filter(university=university_id)
        return queryset

# Get All Users for Specific University
class AllUsers_for_SpecificCampus(generics.ListAPIView):
    serializer_class = CustomUserSerializer
    authentication_classes = [JWTStatelessUserAuthentication]
    permission_classes = [IsSuper_University_Campus_Department]
    def get_queryset(self):
        campus_id = self.kwargs['campus_id']
        queryset = CustomUser.objects.filter(campus=campus_id)
        return queryset
    
# Get All Users for Specific University
class AllUsers_for_SpecificDepartment(generics.ListAPIView):
    serializer_class = CustomUserSerializer
    authentication_classes = [JWTStatelessUserAuthentication]
    permission_classes = [IsSuper_University_Campus_Department]
    def get_queryset(self):
        department_id = self.kwargs['department_id']
        queryset = CustomUser.objects.filter(department=department_id)
        return queryset# Get All Users for Specific University
    
# All Permissions
class PermissionsView(generics.ListAPIView):
    queryset = Permission.objects.all()
    serializer_class = PermissionsSerializer
    authentication_classes = [JWTStatelessUserAuthentication]
    permission_classes = [IsSuper_University_Campus_Department]

# All Permissions and adding permission in Specific Group
class GroupPermissionsView(APIView):
    authentication_classes = [JWTStatelessUserAuthentication]
    permission_classes = [IsSuper_University_Campus_Department]

    def get(self, request, group_id):
        group = get_object_or_404(CustomGroup, id=group_id)
        permissions = group.group.permissions.all().order_by('id')
        serialized_data = PermissionsSerializer(permissions, many=True)
        return Response(serialized_data.data, status=status.HTTP_200_OK)

    def post(self, request, group_id):
        if 'permissions' in request.data:
            permission_ids = request.data.get('permissions', [])

            if not isinstance(permission_ids, list):
                return Response({"permissions": "Invalid permissions data"}, status=status.HTTP_400_BAD_REQUEST)

            group = get_object_or_404(CustomGroup, id=group_id)
            existing_permissions_count = group.group.permissions.filter(id__in=permission_ids).count()

            if existing_permissions_count > 0:
                return Response({"message": "One or more permissions are already associated with the group"}, status=status.HTTP_400_BAD_REQUEST)

            for permission_id in permission_ids:
                if not isinstance(permission_id, int):
                    return Response({"permissions": "Invalid permission ID"}, status=status.HTTP_400_BAD_REQUEST)

                permission = get_object_or_404(Permission, id=permission_id)
                group.group.permissions.add(permission)

            return Response({"message": "Permissions added successfully"}, status=status.HTTP_201_CREATED)
        return Response({"permissions": "This field is required"}, status=status.HTTP_400_BAD_REQUEST)

    
# All Permissions for Specific User
class UserPermissionsView(APIView):
    authentication_classes = [JWTStatelessUserAuthentication]
    permission_classes = [IsSuper_University_Campus_Department]

    def get(self, request, user_id):
        user = get_object_or_404(CustomUser, id=user_id)
        user_groups = user.custom_groups.all()

        all_permissions = set()
        for group in user_groups:
            permissions = group.group.permissions.all()
            all_permissions.update(permissions)

        serialized_data = PermissionsSerializer(all_permissions, many=True)
        return Response(serialized_data.data, status=status.HTTP_200_OK)