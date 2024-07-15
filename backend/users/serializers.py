from rest_framework import serializers
from .models import *
from django.contrib.auth.models import User as auth_user


class StaffSerializer(serializers.ModelSerializer):
    class Meta:
        model=Staff
        fields="__all__"


class UserSerializer(serializers.ModelSerializer):
    username = serializers.CharField(source='auth_user.username')
    class Meta:
        model = User
        fields = [
            'static_id',
            'username',
            'name',
            'email',
            'mobile_num',
            'dob',
            'sex',
            'address',
            'pincode',
            'profile_photo',
            'occupation',
            'auth_user'
        ]
        
class PatientSerializer(UserSerializer):
    class Meta(UserSerializer.Meta):
        model = Patient
        fields = UserSerializer.Meta.fields + [
            'medication',
            'weight',
            'height',
        ]
        
class DoctorSerializer(UserSerializer):
    class Meta:
        model = Doctor
        fields = UserSerializer.Meta.fields + [
            'about',
            'description',
            'rating',
        ]
