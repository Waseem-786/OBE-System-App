# from rest_framework import serializers
# from .models import EntityType, ApprovalGroup, ApprovalRequest

# class EntityTypeSerializer(serializers.ModelSerializer):
#     class Meta:
#         model = EntityType
#         fields = '__all__'

# class ApprovalGroupSerializer(serializers.ModelSerializer):
#     group_name = serializers.CharField(source='group.name', read_only=True)
#     class Meta:
#         model = ApprovalGroup
#         fields = ('entity_type', 'group_name', 'order', 'status')  # Include status

# class ApprovalRequestSerializer(serializers.ModelSerializer):
#     entity_name = serializers.SerializerMethodField()  # Custom method for entity name
#     approval_groups = ApprovalGroupSerializer(source='approvalgroup_set', many=True, read_only=True)  # Nested serializer

#     def get_entity_name(self, obj):
#         # Implement logic to fetch the actual entity name based on entity_type and entity_id
#         # (e.g., query the appropriate model based on entity_type)
#         return "Entity Name (replace with actual name retrieval logic)"

#     class Meta:
#         model = ApprovalRequest
#         fields = ('id', 'entity_type', 'entity_id', 'entity_name', 'previous_data', 'new_data', 'justification', 'status', 'created_at', 'updated_at', 'approval_groups')
