# Riya backend
from rest_framework import generics, status
from rest_framework.response import Response
from rest_framework.decorators import api_view
from reviews.models import Review
from reviews.serializers import ReviewCreateSerializer
from users.models import Patient, Doctor
from images.models import Image
@api_view(['POST'])
def create_review_view(request):
    if request.method == 'POST':
        # Extract static_id values from request data

        # Fetch Patient, Doctor, and Image objects based on static_id
        try:
            patient = Patient.objects.get(auth_user = request.user)
            image = Image.objects.get(static_id=request.data['static_id'])
            doctor = image.doctor
        except (Patient.DoesNotExist, Doctor.DoesNotExist, Image.DoesNotExist) as e:
            return Response({"message": "Patient, Doctor, or Image not found"}, status=status.HTTP_404_NOT_FOUND)

        # Create a Review object
        serializer = ReviewCreateSerializer(data={
            'patient': patient,
            'doctor': doctor,
            'image': image.static_id,
            'review_comment': request.data.get('review_comment'),
            'rating_stars': request.data.get('rating_stars')
        })
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data, status=status.HTTP_201_CREATED)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

