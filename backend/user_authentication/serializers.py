from rest_framework import serializers
from django.contrib.auth.models import User



class AuthUserSerializer(serializers.ModelSerializer):
    class Meta:
        model = User
        fields = ['id','username', 'email', 'password']
        extra_kwargs = {
            'password': {'write_only': True}
        }
        
        
def create(self, validated_data):
    
    password = validated_data.pop('password', None)
    instance = self.Meta.model(**validated_data)
    if password is not None:
        instance.set_password(password)
        instance.save()
    return instance



#  Sending email OTP

from rest_framework import serializers
from django.contrib.auth.models import User
from .models import UserOTP

class EmailSerializer(serializers.Serializer):
    email = serializers.EmailField()

    def validate_email(self, value):
        if not User.objects.filter(email=value).exists():
            raise serializers.ValidationError("User with this email does not exist.")
        return value

class ResetPasswordSerializer(serializers.Serializer):
    email = serializers.EmailField()
    otp = serializers.CharField(max_length=6)
    new_password = serializers.CharField(min_length=8, max_length=128)

    def validate(self, data):
        email = data.get('email')
        otp = data.get('otp')
        if not User.objects.filter(email=email).exists():
            raise serializers.ValidationError({"email": "User with this email does not exist."})
        user = User.objects.get(email=email)
        if not UserOTP.objects.filter(user=user, otp=otp).exists():
            raise serializers.ValidationError({"otp": "Invalid OTP or OTP has expired."})
        return data