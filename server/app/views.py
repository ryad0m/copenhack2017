from django.shortcuts import render

# Create your views here.
from rest_framework import permissions, generics
from rest_framework.exceptions import ValidationError

from rest_framework.response import Response
from rest_framework.views import APIView

from app.methods import get_fb_connection
from .serializers import *
from .models import *





class SearchView(APIView):
    def search(self, query):
        gapi = get_fb_connection(self.request.user)
        result = gapi.get_object('search', q=query, type='user', fields='id,name,picture.type(normal)')['data']
        for user in result:
            user['fbid'] = user['id']
            user.pop('id')
            user['picture'] = user['picture']['data']['url']
        return Response(result)

    def get(self, request, format=None):
        if 'q' not in self.request.query_params:
            raise ValidationError('no q provided')
        return self.search(self.request.query_params['q'])


class PerepihonList(generics.ListCreateAPIView):
    serializer_class = PerepihonSerializer
    permission_classes = (
        permissions.IsAuthenticated,
    )

    def perform_create(self, serializer):
        profile = self.request.user.profile
        serializer.save(author=profile)

    def get_queryset(self):
        return Perepihon.objects.filter(author=self.request.user.profile)


class PerepihonDetails(generics.RetrieveUpdateDestroyAPIView):
    serializer_class = PerepihonSerializer
    permission_classes = (
        permissions.IsAuthenticated,
    )

    def perform_update(self, serializer):
        profile = self.request.user.profile
        serializer.save(author=profile)

    def get_queryset(self):
        return Perepihon.objects.filter(author=self.request.user.profile)


class DiseaseList(generics.ListAPIView):
    serializer_class = DiseaseSerializer
    permission_classes = (
        permissions.IsAuthenticated,
    )
