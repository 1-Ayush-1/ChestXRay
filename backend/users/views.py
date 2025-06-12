### main backend
from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework import status
from images.models import *
from .models import Patient, Doctor
from images.models import Image
from .serializers import PatientSerializer, DoctorSerializer 


##unnati##
from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework import status
from django.contrib.auth.models import User as DjangoUser
from images.models import *
from .models import Patient, Doctor
from .models import User as UserProfile
from images.models import Image
from rest_framework.decorators import authentication_classes, permission_classes

from rest_framework.decorators import api_view
from rest_framework.response import Response
from rest_framework import status
from users.models import Patient, Doctor
from images.models import Image
from images.serializers import ImageSerializer
from django.shortcuts import get_object_or_404
from rest_framework.permissions import IsAuthenticated


@api_view(['GET'])
def doctor_patients_images_view(request):
    if request.method == 'GET':
        # Get the logged-in doctor
        doctor = get_object_or_404(Doctor, auth_user=request.user)

        # Retrieve all images associated with the doctor
        images = Image.objects.filter(doctor=doctor, doctor_comments="No Comments")

        # Extract patient names and original images
        patients_images_data = []
        for image in images:
            patient_name = image.patient.name  # Assuming 'name' is a field in Patient model
            original_image_url = request.build_absolute_uri(image.original_image.url)  # Absolute URL of original image
            patients_images_data.append({
                'patient_name': patient_name,
                'original_image_url': original_image_url,
            })

        return Response(patients_images_data, status=status.HTTP_200_OK)

class DoctorDetailView(APIView):
    permission_classes = [IsAuthenticated]
    def get(self, request):
        print(request.user)
        user_profile = Doctor.objects.filter(auth_user=request.user).first()
        serializer = DoctorSerializer(user_profile)
        return Response(serializer.data)

"""class PatientsListView(APIView):
    def get(self, request):
        user=request.user
        doctor_static_id = request.query_params.get('doctor_static_id')
        doctor = Doctor.objects.filter(static_id=doctor_static_id).first()
        if not doctor:
            return Response({"error": "Doctor not found"}, status=status.HTTP_404_NOT_FOUND)
        
        images = Image.objects.filter(doctor=doctor).values('patient')
        patient_ids = [image['patient'] for image in images]
        patients = Patient.objects.filter(static_id__in=patient_ids).distinct()

        serializer = PatientSerializer(patients, many=True)
        return Response(serializer.data, status=status.HTTP_200_OK)"""





###Abhi_Backend
from django.shortcuts import render
from django.http import JsonResponse
from django.views.decorators.csrf import csrf_exempt
import json
from .models import *
from django.contrib.auth.models import User as AuthUser
from django.core.exceptions import ValidationError
from rest_framework.permissions import IsAuthenticated
from rest_framework.decorators import permission_classes
from chest_xray.permissions import *

@csrf_exempt
@permission_classes([IsAuthenticated])
def AllDoctorsView(request):
    if request.method == 'GET':
        try:
            doctors = Doctor.objects.all()
            doctors_data = []
            for doctor in doctors:
                doctor_info = {
                    'user_id': str(doctor.static_id),
                    'name': doctor.name,
                    'mobile_num': doctor.mobile_num,
                    'about': doctor.about,
                    'profile_photo': doctor.profile_photo.url if doctor.profile_photo else None
                }
                doctors_data.append(doctor_info)

            return JsonResponse({
                'success': True,
                'doctors': doctors_data,
            }, status=200)

        except json.JSONDecodeError as e:
            return JsonResponse({"success": False, "message": "Invalid JSON", "details": str(e)}, status=400)

    return JsonResponse({"success": False, "message": "Only GET requests are allowed"}, status=405)

def handle_profile_photo(file_data):
    # Assuming file_data is a base64-encoded string or a direct upload path
    # Convert and save it if necessary, here just a placeholder
    return file_data
@csrf_exempt
def UpdateDoc(request, id):
    if request.method == 'PUT':
        try:
            doctor = Doctor.objects.get(static_id=id)
            
            data = json.loads(request.body)
            
            doctor.name = data.get('name', doctor.name)
            doctor.email = data.get('email', doctor.email)
            doctor.mobile_num = data.get('mobile_num', doctor.mobile_num)
            doctor.dob = data.get('dob', doctor.dob)
            doctor.sex = data.get('sex', doctor.sex)
            doctor.address = data.get('address', doctor.address)
            doctor.pincode = data.get('pincode', doctor.pincode)
            doctor.about = data.get('about', doctor.about)
            doctor.description = data.get('description', doctor.description)

            doctor.save()

            response_data = {
                'success': True,
                'status_code': 200,
                'message': 'Doctor data updated successfully.',
            }
            return JsonResponse(response_data, status=200)

        except KeyError as e:
            response_data = {
                'success': False,
                'status_code': 400,
                'error_message': f'Missing required field: {e}',
            }
            return JsonResponse(response_data, status=400)

        except Doctor.DoesNotExist:
            response_data = {
                'success': False,
                'status_code': 404,
                'error_message': 'Doctor not found.',
            }
            return JsonResponse(response_data, status=404)

        except Exception as e:
            response_data = {
                'success': False,
                'status_code': 500,
                'error_message': str(e),
            }
            return JsonResponse(response_data, status=500)
    else:
        response_data = {
            'success': False,
            'status_code': 405,
            'error_message': 'Method not allowed. Only PUT requests are allowed.',
        }
        return JsonResponse(response_data, status=405)


@csrf_exempt
# @permission_classes([IsStaff, IsAuthenticated])
def DeleteDoc(req, id):
    if req.method == 'DELETE':
      try:
        # if ((req.user.profile.static_id != id) and not req.user.is_staff):
        #     return JsonResponse({'error': 'You are not authorized to delete this doctor'}, status=403)
        
        doctor = Doctor.objects.get(static_id=id)
        doctor.delete()
        response_data = {
                'success': True,
                'status_code': 200,
                'message': f'Doctor with id {id} deleted successfully.',
            }
        return JsonResponse(response_data, status=200)

      except Doctor.DoesNotExist:
            response_data = {
                'success': False,
                'status_code': 404,
                'error_message': 'Doctor not found.',
            }
            return JsonResponse(response_data, status=404)

      except Exception as e:
            response_data = {
                'success': False,
                'status_code': 500,
                'error_message': str(e),
            }
            return JsonResponse(response_data, status=500)
    else:
        response_data = {
            'success': False,
            'status_code': 405,
            'error_message': 'Method not allowed. Only PUT requests are allowed.',
        }
        return JsonResponse(response_data, status=405)
    

@csrf_exempt
def GetDoc(req, id):
    if req.method == 'GET':
      try:
        doctor = Doctor.objects.get(static_id=id)
        response_data = {
                'success': True,
                'status_code': 200,
                'doctor':{
                'name': doctor.name,
                'email': doctor.email,
                'mobile_num': doctor.mobile_num,
                'dob': doctor.dob,
                'sex': doctor.sex,
                'address': doctor.address,
                'pincode': doctor.pincode,
                'about': doctor.about,
                'description': doctor.description,
                'Occupation':doctor.occupation,
                }
            }
        return JsonResponse(response_data, status=200)

      except Doctor.DoesNotExist:
            response_data = {
                'success': False,
                'status_code': 404,
                'error_message': 'Doctor not found.',
            }
            return JsonResponse(response_data, status=404)

      except Exception as e:
            response_data = {
                'success': False,
                'status_code': 500,
                'error_message': str(e),
            }
            return JsonResponse(response_data, status=500)
    else:
        response_data = {
            'success': False,
            'status_code': 405,
            'error_message': 'Method not allowed. Only PUT requests are allowed.',
        }
        return JsonResponse(response_data, status=405)
    
@csrf_exempt
@permission_classes([IsStaff, IsDoctor])
def PatientView(request):
    if request.method == 'GET':
        try:
            patients =Patient.objects.all()
            patients_data = []
            for patient in patients:
                patient_info = {
                    'user_id': str(patient.static_id),
                    'name': patient.name,
                    'mobile_num': patient.mobile_num,
                    'medication': patient.medication,
                    'profile_photo': patient.profile_photo.url if patient.profile_photo else None
                }
                patients_data.append(patient_info)

            return JsonResponse({
                'success': True,
                'patients': patients_data,
            }, status=200)

        except json.JSONDecodeError as e:
            return JsonResponse({"success": False, "message": "Invalid JSON", "details": str(e)}, status=400)

    return JsonResponse({"success": False, "message": "Only GET requests are allowed"}, status=405)


@csrf_exempt
def UpdatePat(req, id):
    if req.method == 'PUT':
        try:
            data = json.loads(req.body)
            name = data.get('name')
            email = data.get('email')
            mobile_num = data.get('mobile_num')
            dob = data.get('dob')
            sex = data.get('sex')
            address = data.get('address')
            pincode = data.get('pincode')
            medication = data.get('medication')
            weight = data.get('weight')
            height = data.get('height')
            Occupation=data.get('occupation')

            
            patient = Patient.objects.get(static_id=id)

            if name is not None:
                patient.name = name
            if email is not None:
                patient.email = email
            if mobile_num is not None:
                patient.mobile_num = mobile_num
            if dob is not None:
                patient.dob = dob
            if sex is not None:
                patient.sex = sex
            if address is not None:
                patient.address = address
            if pincode is not None:
                patient.pincode = pincode
            if medication is not None:
                patient.medication = medication
            if weight is not None:
                patient.weight = weight
            if height is not None:
                patient.height = height
            if Occupation is not None:
                patient.occupation = Occupation
            patient.save()

            response_data = {
                'success': True,
                'status_code': 200,
                'message': 'Patient data updated successfully.',
            }
            return JsonResponse(response_data, status=200)

        except KeyError as e:
            response_data = {
                'success': False,
                'status_code': 400,
                'error_message': f'Missing required field: {e}',
            }
            return JsonResponse(response_data, status=400)

        except Patient.DoesNotExist:
            response_data = {
                'success': False,
                'status_code': 404,
                'error_message': 'Patient not found.',
            }
            return JsonResponse(response_data, status=404)

        except Exception as e:
            response_data = {
                'success': False,
                'status_code': 500,
                'error_message': str(e),
            }
            return JsonResponse(response_data, status=500)
    else:
        response_data = {
            'success': False,
            'status_code': 405,
            'error_message': 'Method not allowed. Only PUT requests are allowed.',
        }
        return JsonResponse(response_data, status=405)

@csrf_exempt
def DeletePat(req, id):
  if req.method == 'DELETE':
    try:
        patient = Patient.objects.get(static_id=id)
        patient.delete()
        response_data = {
                'success': True,
                'status_code': 200,
                'message': f'Patient with id {id} deleted successfully.',
            }
        return JsonResponse(response_data, status=200)

    except Patient.DoesNotExist:
            response_data = {
                'success': False,
                'status_code': 404,
                'error_message': 'Patient not found.',
            }
            return JsonResponse(response_data, status=404)

    except Exception as e:
            response_data = {
                'success': False,
                'status_code': 500,
                'error_message': str(e),
            }
            return JsonResponse(response_data, status=500)
    else:
        response_data = {
            'success': False,
            'status_code': 405,
            'error_message': 'Method not allowed. Only PUT requests are allowed.',
        }
        return JsonResponse(response_data, status=405)
    

@csrf_exempt
def GetPat(req, id):
 if req.method == 'GET':
    try:
        print('Inside Get Pat')
        patient = Patient.objects.get(static_id=id)
        print(patient.name)
        print(patient.profile_photo)
        profile_photo_url = patient.profile_photo.url if patient.profile_photo else None
        print(profile_photo_url)
        response_data = {
                'success': True,
                'status_code': 200,
                'patient':{
                'name': patient.name,
                'email': patient.email,
                'mobile_num': patient.mobile_num,
                'dob': patient.dob,
                'sex': patient.sex,
                'address': patient.address,
                'pincode': patient.pincode,
                'medication': patient.medication,
                'weight': patient.weight,
                'height':patient.height,
                'Occupation':patient.occupation,
                'profile_photo':profile_photo_url,
                }
            }
        
        return JsonResponse(response_data, status=200)

    except Patient.DoesNotExist:
            response_data = {
                'success': False,
                'status_code': 404,
                'error_message': 'Patient not found.',
            }
            return JsonResponse(response_data, status=404)

    except Exception as e:
            response_data = {
                'success': False,
                'status_code': 500,
                'error_message': str(e),
            }
            return JsonResponse(response_data, status=500)
    else:
        response_data = {
            'success': False,
            'status_code': 405,
            'error_message': 'Method not allowed. Only PUT requests are allowed.',
        }
        return JsonResponse(response_data, status=405)

@csrf_exempt
def AddDoc(request):
    if request.method == 'POST':
        try:
            # Extract data from POST request
            email = request.POST.get('email')
            username = 'abcdefgh' + email  # Example username creation logic
            password = 'password'  # Example password
            name = request.POST.get('name')
            mobile_num = request.POST.get('mobile_num')
            dob = request.POST.get('dob')
            sex = request.POST.get('sex')
            address = request.POST.get('address')
            pincode = request.POST.get('pincode')
            about = request.POST.get('about')
            description = request.POST.get('description')

            # Validate required fields
            required_fields = ['username', 'password', 'email', 'name', 'mobile_num', 'dob', 'sex', 'pincode', 'about', 'description']
            for field in required_fields:
                if not locals()[field]:
                    return JsonResponse({'error': f'{field} is required'}, status=400)

            # Handle profile photo upload
            profile_photo = None
            if 'profile_photo' in request.FILES:
                profile_photo = request.FILES['profile_photo']

            # Create user and doctor objects
            auth_user = AuthUser.objects.create_user(username=username, password=password, email=email)
            doctor = Doctor.objects.create(
                auth_user=auth_user,
                name=name,
                email=email,
                mobile_num=mobile_num,
                dob=dob,
                sex=sex,
                occupation='Doc',
                address=address or '',  # Handle optional fields
                pincode=pincode,
                profile_photo=profile_photo,
                about=about or '',  # Handle optional fields
                description=description or '',  # Handle optional fields
            )

            return JsonResponse({'message': 'Doctor added successfully', 'doctor_id': str(doctor.static_id)}, status=201)

        except KeyError as e:
            return JsonResponse({'error': f'Missing required field: {str(e)}'}, status=400)
        except ValidationError as e:
            return JsonResponse({'error': str(e)}, status=400)
        except Exception as e:
            return JsonResponse({'error': str(e)}, status=500)

    return JsonResponse({'error': 'Invalid request method'}, status=405)

@csrf_exempt
def AddPat(request):
    if request.method == 'POST':
        try:
            email = request.POST.get('email')            
            username = 'abcdefgh'+email
            password = 'password'
            name = request.POST.get('name')
            mobile_num = request.POST.get('mobile_num')
            dob = request.POST.get('dob')
            sex = request.POST.get('sex')
            address = request.POST.get('address')
            pincode = request.POST.get('pincode')
            weight = request.POST.get('weight')
            height = request.POST.get('height')
            medication = request.POST.get('medication')

            # Validate required fields
            required_fields = ['username', 'password', 'email', 'name', 'mobile_num', 'dob', 'sex', 'pincode']
            for field in required_fields:
                if not locals()[field]:
                    return JsonResponse({'error': f'{field} is required'}, status=400)

            # Handle profile photo upload
            profile_photo = None
            if 'profile_photo' in request.FILES:
                profile_photo = request.FILES['profile_photo']
                print('Profile Photo:', profile_photo)

            # Create user and patient objects
            auth_user = AuthUser.objects.create_user(username=username, password=password, email=email)
            patient = Patient.objects.create(
                auth_user=auth_user,
                name=name,
                email=email,
                mobile_num=mobile_num,
                dob=dob,
                sex=sex,
                address=address or '',  
                pincode=pincode,
                profile_photo=profile_photo,
                occupation='Pat',
                weight=weight or '',  
                height=height or '',  
                medication=medication or '',  
            )

            return JsonResponse({'message': 'Patient added successfully', 'patient_id': str(patient.static_id)}, status=201)

        except KeyError as e:
            return JsonResponse({'error': f'Missing required field: {str(e)}'}, status=400)
        except ValidationError as e:
            return JsonResponse({'error': str(e)}, status=400)
        except Exception as e:
            return JsonResponse({'error': str(e)}, status=500)

    return JsonResponse({'error': 'Invalid request method'}, status=405)
    


###unnati##
class UserDetailView(APIView):
    permission_classes = [IsAuthenticated]
    def get(self, request):
        print(request.user)
        user_profile = Patient.objects.filter(auth_user=request.user).first()
        serializer = PatientSerializer(user_profile)
        return Response(serializer.data)


## Sourish 
"""from images.models import Image
from users.serializer import ImageSerializer
from rest_framework.response import Response
from rest_framework import generics
from .models import Doctor
from .serializer import DoctorSerializer
from rest_framework.views import APIView

class DoctorList(APIView):
    def get(self,request):
        queryset = Doctor.objects.all()
        serializer = DoctorSerializer(queryset, many=True)
        return Response(serializer.data,status=200)

class ImageList(APIView):
    def get(self,request):
        queryset = Image.objects.all()
        serializer = ImageSerializer(queryset, many=True)
        return Response(serializer.data, status=200)"""

##Riyaji##
from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework import status
from .models import Patient, Doctor
from rest_framework.parsers import MultiPartParser, FormParser


class DoctorProfileUpdate(APIView):
    

    def patch(self, request):
        user = request.user

        if not user.is_authenticated:
            return Response({"message": "User is not authenticated"}, status=status.HTTP_401_UNAUTHORIZED)
        
        try:
            patient = Doctor.objects.get(auth_user=user)
        except Doctor.DoesNotExist:
            return Response({"message": "Doctor not found"}, status=status.HTTP_404_NOT_FOUND)

        serializer = DoctorSerializer(patient, data=request.data, partial=True)

        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data, status=status.HTTP_200_OK)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)
class PatientProfileUpdate(APIView):

    def patch(self, request):
        user = request.user

        if not user.is_authenticated:
            return Response({"message": "User is not authenticated"}, status=status.HTTP_401_UNAUTHORIZED)
        
        try:
            patient = Patient.objects.get(auth_user=user)
        except Patient.DoesNotExist:
            return Response({"message": "Patient not found"}, status=status.HTTP_404_NOT_FOUND)

        serializer = PatientSerializer(patient, data=request.data, partial=True)

        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data, status=status.HTTP_200_OK)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

##sourish##
from images.models import Image
from users.serializer import ImageSerializer
from rest_framework.response import Response
from rest_framework import generics
from .models import Doctor
from .serializer import DoctorSerializer
from rest_framework.views import APIView

class DoctorList(APIView):
    def get(self,request):
        queryset = Doctor.objects.all()
        serializer = DoctorSerializer(queryset, many=True)
        return Response(serializer.data,status=200)

class ImageList(APIView):
    def get(self,request):
        queryset = Image.objects.all()
        serializer = ImageSerializer(queryset, many=True)
        return Response(serializer.data, status=200)
    


##Saumya

class Patient_View(APIView):
    def get(self, request):
        patient_id = request.query_params.get('patient_id',None)
        name = request.query_params.get('name',None)
        start_date = request.query_params.get('start_date',None)
        end_date = request.query_params.get('end_date',None)

        if patient_id:
            patients = Patient.objects.filter(patient_id=patient_id)
        elif name:
            patients = Patient.objects.filter(name__icontains=name)
        elif start_date and end_date:
            patients = Patient.objects.filter(start_date_gte = start_date, end_date_lte = end_date)
        else:
            return Response({"error": "Invalid parameters"}, status=status.HTTP_400_BAD_REQUEST)

        serializer = PatientSerializer(patients, many=True)
        return Response(serializer.data, status=status.HTTP_200_OK)

