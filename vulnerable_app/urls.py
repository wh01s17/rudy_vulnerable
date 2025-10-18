from django.urls import path
from . import views

urlpatterns = [
    path('', views.home, name='home'),
    path('form/', views.vulnerable_form, name='vulnerable_form'),
    path('upload/', views.upload_endpoint, name='upload_endpoint'),
]
