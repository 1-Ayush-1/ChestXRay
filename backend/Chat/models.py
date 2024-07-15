import uuid
from django.db import models
from users.models import Patient, Doctor
from images.models import Image

class Chat(models.Model):
    static_id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    patient = models.ForeignKey(Patient, on_delete=models.CASCADE, null=False)
    doctor = models.ForeignKey(Doctor, on_delete=models.CASCADE, null=False)
    image = models.ForeignKey(Image, on_delete=models.CASCADE, null=False)

    def __str__(self):
        return f"Chat between {self.patient} and {self.doctor}"
    

class Message(models.Model):
    static_id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    chat = models.ForeignKey(Chat, on_delete=models.CASCADE, related_name='messages', null=False)
    message = models.TextField(null=False)
    timestamp = models.DateTimeField(auto_now_add=True)
    sender = models.CharField(max_length=50, null=False, choices=[('patient', 'Patient'), ('doctor', 'Doctor')])

    def __str__(self):
        return f"Chat from {self.sender} at {self.timestamp}"