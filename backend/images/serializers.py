from rest_framework import serializers

from users.models import Patient
from .models import Image

class ImageSerializer(serializers.ModelSerializer):
    class Meta:
        model = Image
        fields = '__all__'


    
    def create(self, validated_data):
        return Image.objects.create(**validated_data)