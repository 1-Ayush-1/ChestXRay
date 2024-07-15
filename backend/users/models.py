from django.db import models
import uuid
from django.core.validators import RegexValidator
from datetime import date

SEX_CHOICES = [
    ('M', 'Male'),
    ('F', 'Female'),
    ('O', 'Other'),
]

Occupation_choices=[
    ('Doc','Doctor'),
    ('Pat','Patient'),
]

def get_profile_photo_path(instance, filename): 
    return f"profile_photos/{instance.static_id}.{filename.split('.')[-1]}"

# Create your models here.
class User(models.Model):
    static_id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    auth_user = models.OneToOneField('auth.User', on_delete=models.CASCADE)
    name = models.CharField(max_length=100)
    #email = models.CharField(max_length=100, unique=True, validators=[RegexValidator(r'^\w+@\w+\.\w{2,3}$')])
    email=models.EmailField()
    mobile_num = models.CharField(max_length=10, unique=True, validators=[RegexValidator(r'^\d{1,10}$')])
    dob = models.DateField(null=True)
    sex = models.CharField(max_length=1, choices=SEX_CHOICES)
    address = models.TextField(max_length=200, null=True)
    pincode = models.CharField(max_length=6, validators=[RegexValidator(r'^\d{1,6}$')])
    occupation=models.CharField(max_length=3,choices=Occupation_choices,null=True)
    profile_photo = models.ImageField(upload_to=get_profile_photo_path,null=True)
    

    @property
    def age(self):
        try:
            return date.today().year - self.dob.year
        except: return -1
    
    @property
    def useroccupation(self):
        if hasattr(self, 'doctor'):
            return 'Doctor'
        elif hasattr(self, 'patient'):
            return 'Patient'
        return None
    
class Patient(User):
    medication = models.TextField(null=True)
    weight = models.FloatField(null=True)
    height = models.FloatField(null=True)
    # start_date = models.DateField(null=True)
    # end_date = models.DateField(null=True)


class Doctor(User):
    about = models.TextField(null=True)
    description = models.TextField(null=True)

    @property
    def rating(self):
        reviews = self.review_set.all()
        if len(reviews) == 0:
            return 0
        return sum([review.rating_stars for review in reviews]) / len(reviews)


class Staff(models.Model):
   # auth_user = models.OneToOneField('auth.User', related_name='staff_user', on_delete=models.CASCADE)
    UserName=models.CharField(max_length=200)
    UserPassword=models.CharField(max_length=200)