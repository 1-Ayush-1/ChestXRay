from datetime import datetime
import os
import uuid
from django.db import models
from users.models import *


def get_original_image_path(instance, filename):
    return os.path.join('images/original', f"{instance.patient.name}-{datetime.now().strftime('%Y-%m-%d_%H-%M-%S')}")
def get_ai_image_path(instance, filename):
    return os.path.join('images/ai', f"{instance.patient.name}-{datetime.now().strftime('%Y-%m-%d_%H-%M-%S')}")

# Create your models here.
class Image(models.Model):
    static_id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    patient = models.ForeignKey(Patient, on_delete=models.CASCADE, null=False)
    original_image = models.ImageField(upload_to=get_original_image_path, null=False)
    ai_text = models.TextField(null=True)
    ai_image = models.ImageField(upload_to=get_ai_image_path, null=True)
    date_added = models.DateTimeField(auto_now_add=True)
    doctor = models.ForeignKey(Doctor, on_delete=models.CASCADE, null=True)
    doctor_comments = models.TextField(default="No Comments")
    
    def __str__(self):
        return f"{self.static_id}"