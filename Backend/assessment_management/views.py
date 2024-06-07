from django.shortcuts import get_object_or_404
from rest_framework import generics, status
from rest_framework.views import APIView, Response
from rest_framework_simplejwt.authentication import JWTStatelessUserAuthentication
from .models import Assessment
from .serializers import AssessmentSerializer
from user_management.permissions import IsSuper_University_Campus_Department
from .utils import check_question_consistency, convert_questions_with_clos

class CompleteAssessmentCreateView(generics.CreateAPIView):
    queryset = Assessment.objects.all()
    serializer_class = AssessmentSerializer
    permission_classes = [IsSuper_University_Campus_Department]
    authentication_classes = [JWTStatelessUserAuthentication]

    def create(self, request, *args, **kwargs):
        serializer = self.get_serializer(data=request.data)
        if serializer.is_valid():
            try:
                serializer.save()
                return Response(serializer.data, status=status.HTTP_201_CREATED)
            except Exception as e:
                return Response({"error": str(e)}, status=status.HTTP_400_BAD_REQUEST)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)



class CompleteAssessmentDetailView(APIView):
    permission_classes = [IsSuper_University_Campus_Department]
    authentication_classes = [JWTStatelessUserAuthentication]

    def get_object(self, assessment_id):
        return get_object_or_404(Assessment, id=assessment_id)

    def get(self, request, assessment_id, *args, **kwargs):
        assessment = self.get_object(assessment_id)
        serializer = AssessmentSerializer(assessment)
        return Response(serializer.data)

    def put(self, request, assessment_id, *args, **kwargs):
        partial = kwargs.pop('partial', False)
        instance = self.get_object(assessment_id)
        serializer = AssessmentSerializer(instance, data=request.data, partial=partial)
        if serializer.is_valid():
            try:
                serializer.save()
                return Response(serializer.data, status=status.HTTP_200_OK)
            except Exception as e:
                return Response({"error": str(e)}, status=status.HTTP_400_BAD_REQUEST)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

    def delete(self, request, assessment_id, *args, **kwargs):
        instance = self.get_object(assessment_id)
        instance.delete()
        return Response(status=status.HTTP_204_NO_CONTENT)

class AllAssessmentsView(generics.ListAPIView):
    serializer_class = AssessmentSerializer
    permission_classes = [IsSuper_University_Campus_Department]
    authentication_classes = [JWTStatelessUserAuthentication]

    def get_queryset(self):
        batch_id = self.request.query_params.get('batch_id')
        course_id = self.request.query_params.get('course_id')
        teacher_id = self.request.query_params.get('teacher_id')

        if not batch_id or not course_id or not teacher_id:
            return Response("batch_id, course_id, and teacher_id are required parameters.", status=status.HTTP_400_BAD_REQUEST)

        queryset = Assessment.objects.filter(
            batch_id=batch_id,
            course_id=course_id,
            teacher_id=teacher_id
        )

        return queryset

# View for checking question consistency with selected CLOs
class CheckQuestionConsistencyView(APIView):
    permission_classes = [IsSuper_University_Campus_Department]
    authentication_classes = [JWTStatelessUserAuthentication]

    def post(self, request, *args, **kwargs):
        question_description = request.data.get('question_description', '')
        clo_ids = request.data.get('clo_ids', [])

        if not question_description or not clo_ids:
            return Response({"status": "error", "message": "Question description and CLO IDs are required."}, status=status.HTTP_400_BAD_REQUEST)

        result = check_question_consistency(question_description, clo_ids)
        return Response(result, status=status.HTTP_200_OK if result['status'] == 'success' else status.HTTP_400_BAD_REQUEST)

class RefineCompleteAssessmentView(APIView):
    permission_classes = [IsSuper_University_Campus_Department]
    authentication_classes = [JWTStatelessUserAuthentication]

    def post(self, request, *args, **kwargs):
        data = request.data

        # Convert all questions and their parts using multiple AI calls
        conversion_result = convert_questions_with_clos(data.get('questions', []))
        if conversion_result['status'] == 'success':
            return Response(conversion_result['questions'], status=status.HTTP_200_OK)
        else:
            return Response({"status": "error", "message": conversion_result['message']}, status=status.HTTP_400_BAD_REQUEST)
