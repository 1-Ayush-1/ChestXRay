from django.urls import path,include
from .views import *


urlpatterns = [
    path('upload_scan/', upload_scan.as_view(), name='upload_scan'),
    path('image_detail/', ImageDetailView.as_view(), name='image_detail'),
]
##unnati##
urlpatterns+=[
    path('reports/', ReportListView.as_view(), name='reports-list'),
    path('reports_details/<uuid:static_id>/', ReportView.as_view(), name='reports-list'),
    path('doc_comments/<uuid:static_id>/', UpdateDoctorComments.as_view(), name='update_doctor_comments'),

]

##soursish##
urlpatterns+=[
    path('add_doc',UpdateDoctorField.as_view(),name='add_doc_field'),
]