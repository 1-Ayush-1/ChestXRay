from users.serializers import UserSerializer, PatientSerializer, DoctorSerializer
from .serializers import AuthUserSerializer,EmailSerializer, ResetPasswordSerializer
import json
from django.http import JsonResponse
from django.views.decorators.csrf import csrf_exempt
from rest_framework.authentication import SessionAuthentication, TokenAuthentication
from rest_framework.permissions import IsAuthenticated
from rest_framework.decorators import authentication_classes, permission_classes
from rest_framework.response import Response
from django.contrib.auth.models import User as auth_user
from users.models import User, Patient, Doctor
from rest_framework.decorators import api_view
from django.shortcuts import get_object_or_404
from rest_framework.authtoken.models import Token
from rest_framework import status
from users.models import Staff
from .models import UserOTP
from rest_framework.views import APIView
from django.utils.crypto import get_random_string
from django.contrib.auth.hashers import make_password
from django.core.mail import send_mail



@api_view(['POST'])
def login(request):
    user = get_object_or_404(auth_user,email= request.data['email'])
    if not user.check_password(request.data['password']):
        return Response({'detail':'Incorrect credentials!'},status=status.HTTP_404_NOT_FOUND)
    token ,created= Token.objects.get_or_create(user=user)
    profile = User.objects.get(auth_user=user)
    if (profile.occupation == 'Patient'):
        profile = Patient.objects.get(auth_user=user)
        serializer = PatientSerializer(instance=profile)
    elif (profile.occupation == 'Doctor'):
        profile = Doctor.objects.get(auth_user=user)
        serializer = DoctorSerializer(instance=profile)
    else:
        serializer = UserSerializer(instance=profile)
    return Response({"token":token.key,"user":serializer.data})


@api_view(['POST'])
def signup(request):
    serializer = AuthUserSerializer(data=request.data)
    if (auth_user.objects.filter(email = request.data['email']).exists()):
        return Response({"message":"User with this email already exists"},status=status.HTTP_400_BAD_REQUEST)
    if (User.objects.filter(email = request.data['email']).exists()):
        return Response({"message":"User with this email already exists"},status=status.HTTP_400_BAD_REQUEST)
    if request.data['password'] != request.data['confirm_password']:
        return Response({"message" : "Password doesn't match"}, status=status.HTTP_400_BAD_REQUEST)
    
    if serializer.is_valid():
        serializer.save()
        user = auth_user.objects.get(username=request.data['username'])
        token= Token.objects.create(user=user)
        user.set_password(request.data['password'])
        user.save()

        profile, created = Patient.objects.get_or_create(auth_user=user, email=user.email, mobile_num = request.data['mobile_num'])
        profile.save()
        profileserializer = PatientSerializer(instance=profile)
        return Response({"token":token.key,"user":profileserializer.data})
    return Response(serializer.errors,status=status.HTTP_400_BAD_REQUEST)

@csrf_exempt
def Staff_Login(request):
    if request.method=='POST':
        try:
            data = json.loads(request.body)
            username = data.get("UserName")
            password = data.get("UserPassword")
            if not username or not password:
                return JsonResponse({"success": False, "message": "username and password are required"}, status=400)
        
            try:
                user = Staff.objects.get(UserName=username)
            except Staff.DoesNotExist:
                return JsonResponse({"success": False, "message": "auth_user not found"}, status=404)

            if password != user.UserPassword:
                return JsonResponse({"success": False, "message": "Invalid password"}, status=401)

            return JsonResponse({"success": True, "message": "Login successful"}, status=200)

        except json.JSONDecodeError as e:
            return JsonResponse({"success": False, "message": "Invalid JSON", "details": str(e)}, status=400)

    return JsonResponse({"success": False, "message": "Only POST requests are allowed"}, status=405)


@api_view(['GET'])
@authentication_classes([SessionAuthentication,TokenAuthentication])
@permission_classes([IsAuthenticated])
def test_token(request):
    return Response("passed for {}".format(request.user.email))




#Sending email OTP code


                   
     
     
     
#Forgot Password and Reset Password

class SendOTPView(APIView):
    def post(self, request):
        serializer = EmailSerializer(data=request.data)
        serializer.is_valid(raise_exception=True)

        email = serializer.validated_data['email']
        user = auth_user.objects.get(email=email)
        otp = get_random_string(length=6, allowed_chars='0123456789')
        
        UserOTP.objects.update_or_create(user=user, defaults={'otp': otp})
        
        send_mail(
            'Your OTP Code',
            f'Your OTP code is {otp}',
            email,
            [email],
            fail_silently=False,
        )
        return Response({'message': 'OTP sent'}, status=status.HTTP_200_OK)

class ResetPasswordView(APIView):
    def post(self, request):
        serializer = ResetPasswordSerializer(data=request.data)
        serializer.is_valid(raise_exception=True)

        email = serializer.validated_data['email']
        otp = serializer.validated_data['otp']
        new_password = serializer.validated_data['new_password']
        
        user = auth_user.objects.get(email=email)
        user_otp = UserOTP.objects.get(user=user, otp=otp)
        
        user.password = make_password(new_password)
        user.save()
        
        user_otp.delete()
        
        return Response({'message': 'Password reset successful'}, status=status.HTTP_200_OK)


