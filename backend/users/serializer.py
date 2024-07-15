from pathlib import __all__
from rest_framework import serializers
from .models import Doctor, Patient
from images.models import Image

class DoctorSerializer(serializers.ModelSerializer):
    class Meta:
        model = Doctor
        fields = ['static_id', 'auth_user', 'name', 'email', 'mobile_num', 'dob', 'sex', 'address', 'pincode', 'age', 'about', 'description', 'rating','profile_photo']

class PatientSerializer(serializers.ModelSerializer):
    class Meta:
        model = Patient
        fields = '__all__'

class ImageSerializer(serializers.ModelSerializer):
    doctor = DoctorSerializer(read_only=True)

    class Meta:
        model = Image
        fields = '__all__'