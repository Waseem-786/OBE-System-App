GET --> api/role --> All Roles
POST --> api/role --> Creating a new Role

GET --> api/role/<id> --> Get Specific Role Name
PUT/PATCH --> api/role/<id> --> Update Role Name
DELETE --> api/role/<id> --> Delete Specific Role

GET --> user-group/<GroupName> --> All Users present in specific group
POST --> user-group/<GroupName> --> Adding User in specific group
DELETE --> user-group/<GroupName> --> Deleting User from group
PUT --> user-group/<GroupName> --> Update User Group from one to another


POST --> auth/jwt/create --> Token Creation
POST --> auth/jwt/verify --> Token Validation
POST --> auth/jwt/refresh --> Creating Access token from Refresh token

GET --> auth/users/ --> Getting User Data
POST --> auth/users/ --> Creating a User
