from rest_framework import generics
from .models import ToDo
from .serializer import TodoSerializer

class TodoGetCreate(generics.ListCreateAPIView):
    queryset = ToDo.objects.all()
    serializer_class = TodoSerializer

class TodoUpdateDelete(generics.RetrieveUpdateDestroyAPIView):
    queryset = ToDo.objects.all()
    serializer_class = TodoSerializer

