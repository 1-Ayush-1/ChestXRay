from django.urls import path
from .import views
from .views import create_review_view

urlpatterns = [
    path('create_review/', create_review_view, name='create-review'),
]
# reviews/urls.py