from django.urls import path
from . import views
from .views import *

urlpatterns = [
    path("doctor-view/", AllDoctorsView, name="doctor_view"),
    path("update-doc/<uuid:id>", UpdateDoc, name="update_doc"),
    path("delete-doc/<uuid:id>", DeleteDoc, name="delete_doc"),
    path("get-doc/<uuid:id>", GetDoc, name="get_doc"),
    path("add-doc/", AddDoc, name="add_doc"),

    path("patient-view/", PatientView, name="patient_view"),
    path("update-pat/<uuid:id>", UpdatePat, name="update_pat"),
    path("delete-pat/<uuid:id>", DeletePat, name="delete_pat"),
    path("get-pat/<uuid:id>", GetPat, name="get_pat"),
    path("add-pat/", AddPat, name="add_pat"),
    
    path('patients/', doctor_patients_images_view, name='patients_list'),
    path('doctortanish/', DoctorDetailView.as_view(), name='doctor_detail'),
]
##unnati##

urlpatterns+=[ path('user_details/', UserDetailView.as_view(), name='user-detail'),
    ]
##riya##
urlpatterns+=[ 
    path('patient_profile/',PatientProfileUpdate.as_view(), name='patient-profile'),
    path('doctor_profile/', DoctorProfileUpdate.as_view(), name='doctor-profile'),
    
]
##soursih##
urlpatterns+=[
    path('image/', ImageList.as_view(), name='image_list'),
    path('doctor/', DoctorList.as_view(), name='doctor_detail'),
    path('get_patient_details/', Patient_View.as_view(), name='get_patient_details')
]