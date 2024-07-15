from rest_framework import serializers
from .models import Review
from users.models import Patient, Doctor
from images.models import Image

class ReviewCreateSerializer(serializers.ModelSerializer):
    class Meta:
        model = Review
        fields = '__all__'

"""class ReviewCreateSerializer(serializers.ModelSerializer):
    class Meta:
        model = Review
        fields = ['patient', 'doctor', 'image']

    def create(self, validated_data):
        review = Review.objects.create(**validated_data)
        return review"""