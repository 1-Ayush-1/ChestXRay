from django.urls import path
from . import views
from .views import SendOTPView, ResetPasswordView

urlpatterns = [
    path("staff-login/", views.Staff_Login, name="staff_login"),
    path("login/",views.login),
    path("signup/",views.signup),
    path("test_token/",views.test_token),


  #Sending email otp code
    path('send-otp/', SendOTPView.as_view(), name='send-otp'),
    path('reset-password/', ResetPasswordView.as_view(), name='reset-password'),
]
