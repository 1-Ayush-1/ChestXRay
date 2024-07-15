from rest_framework.generics import CreateAPIView
from rest_framework.permissions import IsAuthenticated
from rest_framework.response import Response
from rest_framework import status
from rest_framework.views import APIView
from users.models import *
from .serializers import *



##unnati##
from rest_framework import generics
from rest_framework.views import APIView
from .models import Image
from .serializers import ImageSerializer
from django.shortcuts import get_object_or_404
from django.http import Http404
from users.models import User
from rest_framework.response import Response
import uuid
from django.utils.timezone import datetime
from rest_framework.exceptions import NotFound

# Create your views here.
class upload_scan(CreateAPIView):
    permission_classes = [IsAuthenticated]

    def create(self, request, *args, **kwargs):
        try:
            original_image = request.FILES.get('original_image')
            if not original_image:
                return Response({"error": "No file provided"}, status=status.HTTP_400_BAD_REQUEST)
            
            patient_static_id = request.data.get('patient_static_id')
            if not patient_static_id:
                return Response({"error": "No patient_static_id provided"}, status=status.HTTP_400_BAD_REQUEST)
            
            patient_obj = Patient.objects.filter(static_id=patient_static_id).first()
            if not patient_obj:
                return Response({"error": "Patient not found"}, status=status.HTTP_404_NOT_FOUND)
            
            serializer = ImageSerializer(data={'original_image': original_image, 'patient': patient_obj})
            if serializer.is_valid():
                serializer.save()
                return Response(serializer.data, status=status.HTTP_201_CREATED)
            else:
                return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)
        except Exception as e:
            return Response({"error": str(e)}, status=status.HTTP_500_INTERNAL_SERVER_ERROR)
        



class ImageDetailView(APIView):
    def get(self, request):
        static_id = request.query_params.get('static_id')
        image = Image.objects.filter(static_id = static_id).first()
        if not image:
            return Response({"message" : "No img"}, status=status.HTTP_400_BAD_REQUEST)
        serializer = ImageSerializer(image)
        return Response({"data" : serializer.data}, status=status.HTTP_200_OK)

##unnati##
class ReportListView(generics.ListAPIView):
    permission_classes = [IsAuthenticated]
    serializer_class = ImageSerializer

    def get_queryset(self):
        user = self.request.user

        try:
            patient = Patient.objects.get(auth_user=user)
        except Patient.DoesNotExist:
            raise NotFound("Patient profile not found")

        # Retrieve date parameter from request, or use current date if not provided
        date_param = self.request.query_params.get('date', None)
        if date_param:
            try:
                date_limit = datetime.strptime(date_param, '%Y-%m-%d').date()
                queryset = Image.objects.filter(
                    patient__static_id=patient.static_id,
                    date_added__date__lte=date_limit
                )
            except ValueError:
                return Response({"message": "Invalid date format"}, status=400)  # Return a 400 Bad Request for invalid date format
        else:
            queryset = Image.objects.filter(patient__static_id=patient.static_id)

        return queryset


class ReportView(generics.RetrieveAPIView):
    serializer_class = ImageSerializer
    lookup_field = 'static_id'
    
    def get_object(self):
        static_id = self.kwargs['static_id']
        try:
            uuid_obj = uuid.UUID(str(static_id))
        except ValueError:
            raise Http404("Invalid UUID format")

        return get_object_or_404(Image, static_id=uuid_obj)

class UpdateDoctorComments(APIView):
    def patch(self, request, static_id):
        try:
            image = Image.objects.get(static_id=static_id)
        except Image.DoesNotExist:
            # If Image with the given static_id does not exist, return a 404 error response
            return Response({"error": "Image not found"}, status=status.HTTP_404_NOT_FOUND)

        serializer = ImageSerializer(instance=image, data=request.data, partial=True)
        
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data)
        else:
            return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)
        
class UpdateDoctorField(APIView):
    def patch(self,request):
        try:
            image=Image.objects.get(static_id=request.data['image_static_id'])
            doctor=Doctor.objects.get(static_id=request.data['doctor_static_id'])
            image.doctor = doctor
            image.save()
            return Response({"message":"done"},status=status.HTTP_200_OK)
        except Image.DoesNotExist or Doctor.DoesNotExist:
            return Response({"message":"Image OR doctor not found"},status=status.HTTP_400_BAD_REQUEST)
        
        