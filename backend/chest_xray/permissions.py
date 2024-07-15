from rest_framework.permissions import BasePermission

class IsStaff(BasePermission):
    def has_permission(self, request, view):
        return request.user.staff_user.exists()

class IsDoctor(BasePermission):
    def has_permission(self, request, view):
        return request.user.doctor_user.exists()