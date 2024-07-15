import uuid
from django.db import models
from users.models import Patient, Doctor
from images.models import Image

class Review(models.Model):
    static_id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    patient = models.ForeignKey(Patient, on_delete=models.CASCADE, null=False)
    doctor = models.ForeignKey(Doctor, on_delete=models.CASCADE, null=False)
    image = models.ForeignKey(Image, on_delete=models.CASCADE, null=False)
    review_comment = models.TextField(null=True, blank=True)
    rating_stars = models.IntegerField(null=True)

    def __str__(self):
        return f"Review by {self.patient.name} for {self.doctor.name} with rating {self.rating_stars}"