from rest_framework.response import Response
from rest_framework import generics, status
from rest_framework.views import APIView
from django.shortcuts import get_object_or_404
from .models import CustomUser, CustomGroup
from django.contrib.auth.models import Group
from university_management.models import University, Campus, Department
from .serializers import RoleSerializer, CustomUserSerializer, UniversityAdminUserSerializer, CampusAdminUserSerializer, DepartmentAdminUserSerializer, TopLevelRoleSerializer, UniversityLevelRoleSerializer, CampusLevelRoleSerializer, DepartmentLevelRoleSerializer
from .permissions import IsSuperUser, IsUniversityAdmin, IsCampusAdmin, IsDepartmentAdmin, IsSuper_University_Campus, IsSuper_University, IsSuper_University_Campus_Department
from rest_framework_simplejwt.authentication import JWTStatelessUserAuthentication
from django.db.models import Q


# Top Level Roles
class TopLevelRoles(APIView):
    permission_classes = [IsSuperUser]
    authentication_classes = [JWTStatelessUserAuthentication]

    def get(self, request):
        roles = CustomGroup.objects.filter(
            university__id=0,
            campus__id=0,
            department__id=0,
        )
        serialized_data = TopLevelRoleSerializer(roles, many=True)
        return Response(serialized_data.data,status=status.HTTP_200_OK)

    def post(self, request):
        required_fields = ['name']
        errors = {}
        if not all(field in request.data for field in required_fields):
            errors = {field: ["This field is required."] for field in required_fields}
            return Response(errors,status=status.HTTP_400_BAD_REQUEST)

        role_name = request.data['name']
        group = Group.objects.create(name=role_name)
        # Create a new CustomGroup instance
        custom_group = CustomGroup.objects.create(group=group)
        
        # Serialize the data
        serialized_data = TopLevelRoleSerializer(custom_group)
        
        # Return the serialized data in the response
        return Response(serialized_data.data, status=status.HTTP_201_CREATED)
    
class UniversityLevelRoles(APIView):
    authentication_classes = [JWTStatelessUserAuthentication]
    permission_classes = [IsUniversityAdmin]

    def get(self, request,university_name):
        university = get_object_or_404(University,name=university_name)
        roles = CustomGroup.objects.filter(
            university__id=university.id,
            campus__id=0,
            department__id=0,
        )

        serialized_data = UniversityLevelRoleSerializer(roles, many=True)
        return Response(serialized_data.data, status=status.HTTP_200_OK)
    
    def post(self, request, university_name):
        university = get_object_or_404(University, name=university_name)
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
            serialized_data = UniversityLevelRoleSerializer(custom_group)
        
            # Return the serialized data in the response
            return Response(serialized_data.data, status=status.HTTP_201_CREATED)
        else:
            # If the group already exists and mapped, return an appropriate response
            return Response({'message': 'Role already exists'}, status=status.HTTP_200_OK)
    

class CampusLevelRoles(APIView):
    authentication_classes = [JWTStatelessUserAuthentication]
    permission_classes = [IsCampusAdmin]

    def get(self, request,campus_name):
        user = CustomUser.objects.get(id=request.user.id)
        university = user.university
        # If the requested user doesn't have a university associated, return a 404 response
        if university is None or university==0:
            return Response({'detail':"The requested user is not associated with any university."}, status=status.HTTP_401_UNAUTHORIZED)
        
        campus = get_object_or_404(Campus,name=campus_name)
        roles = CustomGroup.objects.filter(
            university__id=university.id,
            campus__id=campus.id,
            department__id=0,
        )

        serialized_data = CampusLevelRoleSerializer(roles, many=True)
        return Response(serialized_data.data, status=status.HTTP_200_OK)
    
    def post(self, request, campus_name):
        user = CustomUser.objects.get(id=request.user.id)
        university = user.university

        # If the requested user doesn't have a university associated, return a 404 response
        if university is None or university==0:
            raise Response({'detail':"The requested user is not associated with any university."}, status=status.HTTP_401_UNAUTHORIZED)
        

        campus = get_object_or_404(Campus, name=campus_name)
        required_fields = ['name']
        if not all(field in request.data for field in required_fields):
            errors = {field: ['This field is required'] for field in required_fields}
            return Response(errors, status=status.HTTP_400_BAD_REQUEST)

        role_name = request.data['name']
        
        # Retrieve the CustomUser instance. So that we can restrict user that specific user can only add role in his/her university. NUST user can't add role in FAST university.
        get_object_or_404(CustomUser, id=request.user.id, university=university, campus=campus)
        
        # Check if the group already exists. If it isn't it will create else nothing. 
        group, created = Group.objects.get_or_create(name=role_name)
        
        # If the group was created, create a new CustomGroup instance
        custom_group, mapped = CustomGroup.objects.get_or_create(group=group, university=university, campus=campus)
        
        if mapped:
            # Serialize the data
            serialized_data = CampusLevelRoleSerializer(custom_group)
        
            # Return the serialized data in the response
            return Response(serialized_data.data, status=status.HTTP_201_CREATED)
        else:
            # If the group already exists and mapped, return an appropriate response
            return Response({'message': 'Role already exists'}, status=status.HTTP_200_OK)
        


class DepartmentLevelRoles(APIView):
    authentication_classes = [JWTStatelessUserAuthentication]
    permission_classes = [IsSuper_University_Campus_Department]

    def get(self, request,department_name):
        user = CustomUser.objects.get(id=request.user.id)
        university = user.university
        campus = user.campus
        
        # If the requested user doesn't have a university or campus associated, return a 401 response
        if university is None or university==0:
            return Response({'detail':"The requested user is not associated with any university."}, status=status.HTTP_401_UNAUTHORIZED)
        if campus is None or campus==0:
            return Response({'detail':"The requested user is not associated with any campus."}, status=status.HTTP_401_UNAUTHORIZED)
        
        department = get_object_or_404(Department,name=department_name)
        roles = CustomGroup.objects.filter(
            university__id=university.id,
            campus__id=campus.id,
            department__id=department.id,
        )

        serialized_data = DepartmentLevelRoleSerializer(roles, many=True)
        return Response(serialized_data.data, status=status.HTTP_200_OK)
    
    def post(self, request, department_name):
        user = CustomUser.objects.get(id=request.user.id)
        university = user.university
        campus = user.campus

        # If the requested user doesn't have a university associated, return a 404 response
        if university is None or university==0:
            raise Response({'detail':"The requested user is not associated with any university."}, status=status.HTTP_401_UNAUTHORIZED)
        if campus is None or campus==0:
            return Response({'detail':"The requested user is not associated with any campus."}, status=status.HTTP_401_UNAUTHORIZED)

        department = get_object_or_404(Department, name=department_name)
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
        custom_group, mapped = CustomGroup.objects.get_or_create(group=group, university=university, campus=campus, department=department)
        
        if mapped:
            # Serialize the data
            serialized_data = DepartmentLevelRoleSerializer(custom_group)
        
            # Return the serialized data in the response
            return Response(serialized_data.data, status=status.HTTP_201_CREATED)
        else:
            # If the group already exists and mapped, return an appropriate response
            return Response({'message': 'Role already exists'}, status=status.HTTP_200_OK)
        


class AddUserToTopLevelGroupView(APIView):
    permission_classes = [IsSuperUser]
    authentication_classes = [JWTStatelessUserAuthentication]
    
    def get(self,request, group_name):
        group = get_object_or_404(Group, name=group_name)
        custom_group = get_object_or_404(
                    CustomGroup,
                    group=group,
                    university__id=0,
                    campus__id=0,
                    department__id=0,
                )
        users = custom_group.user.all()
        serialized_data = UniversityAdminUserSerializer(users,many=True)
        return Response(serialized_data.data,status=status.HTTP_200_OK)
        
        
    def post(self,request, group_name):
        # Check if 'username' is present in the request data
        if 'username' in request.data:
            username = request.data['username']
            # Retrieve the user object
            user = get_object_or_404(CustomUser, username=username)
            
            # Retrieve the group object
            group = get_object_or_404(Group, name=group_name)

            # Check if the group exists in CustomGroup for the specified conditions (university, campus, department)
            custom_group = get_object_or_404(
                CustomGroup,
                group=group,
                university__id=0,  # Assuming 0 is a placeholder for unspecified university
                campus__id=0,      # Assuming 0 is a placeholder for unspecified campus
                department__id=0,  # Assuming 0 is a placeholder for unspecified department
            )

            if user in custom_group.user.all():
                # If the user is already in the group, return appropriate response
                return Response({"message": f"User {user.username} is already in {group.name} group."}, status=status.HTTP_200_OK)
            else:
                # Add the user to the group
                custom_group.user.add(user)
                return Response({"message": f"User added to {group_name} group"}, status=status.HTTP_201_CREATED)
        else:
            # If 'username' is not present in the request data, return appropriate response
            return Response({"username": "This field is required"}, status=status.HTTP_400_BAD_REQUEST)

    # def delete(self,request,id):
    #     if 'username' in request.data:
    #         name = request.data['username']
    #         user = get_object_or_404(CustomUser,username=name)
    #         group = CustomGroup.objects.get(name='university_admin')
    #         group.user_set.remove(user)
    #         return Response({"message":f"User Deleted from University Admin group"},status=status.HTTP_200_OK)
    #     else:
    #         return Response({"username":"This field is required"},status=status.HTTP_400_BAD_REQUEST)


class AddUserToUniversityLevelGroupView(APIView):
    permission_classes = [IsUniversityAdmin]
    authentication_classes = [JWTStatelessUserAuthentication]
    
    def get(self,request, group_name):
        requested_user = CustomUser.objects.get(id=request.user.id)
        university_id = requested_user.university.id
    
        group = get_object_or_404(Group, name=group_name)
        custom_group = get_object_or_404(
            CustomGroup, 
            group=group,
            university__id=university_id,
            campus__id=0,
            department__id=0,
        )
        users = custom_group.user.all()
        serialized_data = CampusAdminUserSerializer(users,many=True)
        return Response(serialized_data.data,status=status.HTTP_200_OK)
        
        
    def post(self,request, group_name):
        if 'username' in request.data:
            name = request.data['username']
            user = get_object_or_404(CustomUser,username=name)
            
            requested_user = CustomUser.objects.get(id=request.user.id)
            university_id = requested_user.university.id

            # Retrieve the group object
            group = get_object_or_404(Group, name=group_name)

            # Check if the group exists in CustomGroup for the specified conditions (university, campus, department)
            custom_group = get_object_or_404(
                CustomGroup, 
                group=group,
                university__id=university_id,
                campus__id=0,
                department__id=0,
            )

            if user in custom_group.user.all():
                # If the user is already in the group, return appropriate response
                return Response({"message": f"User {user.username} is already in {group.name} group."}, status=status.HTTP_200_OK)
            else:
                # Add the user to the group
                custom_group.user.add(user)
                return Response({"message": f"User added to {group_name} group"}, status=status.HTTP_201_CREATED)
        else:
            # If 'username' is not present in the request data, return appropriate response
            return Response({"username": "This field is required"}, status=status.HTTP_400_BAD_REQUEST)
        
    # def delete(self,request,id):
    #     if 'username' in request.data:
    #         name = request.data['username']
    #         user = get_object_or_404(CustomUser,username=name)
    #         group = CustomGroup.objects.get(name='campus_admin')
    #         group.user_set.remove(user)
    #         return Response({"message":f"User Deleted from Campus Admin group"},status=status.HTTP_200_OK)
    #     else:
    #         return Response({"username":"This field is required"},status=status.HTTP_400_BAD_REQUEST)


class AddUserToCampusLevelGroupView(APIView):
    permission_classes = [IsCampusAdmin]
    authentication_classes = [JWTStatelessUserAuthentication]
    
    def get(self,request, group_name):
        requested_user = CustomUser.objects.get(id=request.user.id)
        university_id = requested_user.university.id
        campus_id = requested_user.campus.id
        
        group = get_object_or_404(Group, name=group_name)
        custom_group = get_object_or_404(
                CustomGroup,
                group=group,
                university__id=university_id,
                campus__id=campus_id,
                department__id=0,
            )
        users = custom_group.user.all()
        serialized_data = DepartmentAdminUserSerializer(users,many=True)
        return Response(serialized_data.data,status=status.HTTP_200_OK)
        
        
    def post(self,request, group_name):
        if 'username' in request.data:
            name = request.data['username']
            user = get_object_or_404(CustomUser,username=name)
            
            requested_user = CustomUser.objects.get(id=request.user.id)
            university_id = requested_user.university.id
            campus_id = requested_user.campus.id
            
            # Retrieve the group object
            group = get_object_or_404(Group, name=group_name)

            # Check if the group exists in CustomGroup for the specified conditions (university, campus, department)
            custom_group = get_object_or_404(
                    CustomGroup,
                    group=group,
                    university__id=university_id,
                    campus__id=campus_id,
                    department__id=0,
                )
            
            
            if user in custom_group.user.all():
                # If the user is already in the group, return appropriate response
                return Response({"message": f"User {user.username} is already in {group.name} group."}, status=status.HTTP_200_OK)
            else:
                # Add the user to the group
                custom_group.user.add(user)
                return Response({"message": f"User added to {group_name} group"}, status=status.HTTP_201_CREATED)
        else:
            # If 'username' is not present in the request data, return appropriate response
            return Response({"username": "This field is required"}, status=status.HTTP_400_BAD_REQUEST)
        
    # def delete(self,request,id):
    #     if 'username' in request.data:
    #         name = request.data['username']
    #         user = get_object_or_404(CustomUser,username=name)
    #         group = CustomGroup.objects.get(name='department_admin')
    #         group.user_set.remove(user)
    #         return Response({"message":f"User Deleted from Department Admin group"},status=status.HTTP_200_OK)
    #     else:
    #         return Response({"username":"This field is required"},status=status.HTTP_400_BAD_REQUEST)



class AddUserToDepartmentLevelGroupView(APIView):
    permission_classes = [IsDepartmentAdmin]
    authentication_classes = [JWTStatelessUserAuthentication]
    
    def get(self,request, group_name):
        requested_user = CustomUser.objects.get(id=request.user.id)
        university_id = requested_user.university.id
        campus_id = requested_user.campus.id
        department_id = requested_user.department.id
        
        group = get_object_or_404(Group, name=group_name)
        custom_group = get_object_or_404(
                CustomGroup,
                group=group,
                university__id=university_id,
                campus__id=campus_id,
                department__id=department_id,
            )
        
        users = custom_group.user.all()
        serialized_data = DepartmentAdminUserSerializer(users,many=True)
        return Response(serialized_data.data,status=status.HTTP_200_OK)
        
        
    def post(self,request, group_name):
        if 'username' in request.data:
            name = request.data['username']
            user = get_object_or_404(CustomUser,username=name)
            
            requested_user = CustomUser.objects.get(id=request.user.id)
            university_id = requested_user.university.id
            campus_id = requested_user.campus.id
            department_id = requested_user.department.id
            
            # Retrieve the group object
            group = get_object_or_404(Group, name=group_name)

            # Check if the group exists in CustomGroup for the specified conditions (university, campus, department)
            custom_group = get_object_or_404(
                    CustomGroup,
                    name=group_name,
                    university__id=university_id,
                    campus__id=campus_id,
                    department__id=department_id,
                )

            
            if user in custom_group.user.all():
                # If the user is already in the group, return appropriate response
                return Response({"message": f"User {user.username} is already in {group.name} group."}, status=status.HTTP_200_OK)
            else:
                # Add the user to the group
                custom_group.user.add(user)
                return Response({"message": f"User added to {group_name} group"}, status=status.HTTP_201_CREATED)
        else:
            # If 'username' is not present in the request data, return appropriate response
            return Response({"username": "This field is required"}, status=status.HTTP_400_BAD_REQUEST)
        
    # def delete(self,request,id):
    #     if 'username' in request.data:
    #         name = request.data['username']
    #         user = get_object_or_404(CustomUser,username=name)
    #         group = CustomGroup.objects.get(name='department_admin')
    #         group.user_set.remove(user)
    #         return Response({"message":f"User Deleted from Department Admin group"},status=status.HTTP_200_OK)
    #     else:
    #         return Response({"username":"This field is required"},status=status.HTTP_400_BAD_REQUEST)


class AllUsers(generics.ListAPIView):
    queryset = CustomUser.objects.all()
    serializer_class = CustomUserSerializer
    authentication_classes = [JWTStatelessUserAuthentication]
    permission_classes = [IsSuperUser]