from django.shortcuts import render

# Create your views here.
from rest_framework import permissions, generics
from rest_framework.response import Response
from rest_framework.views import APIView

from app.methods import get_fb_connection
from .serializers import *
from .models import *


class SearchView(APIView):
    def process_list(self, result):
        for user in result:
            user['fbid'] = user['id']
            user.pop('id')
            user['picture'] = user['picture']['data']['url']
        return result

    def get_friends(self):
        gapi = get_fb_connection(self.request.user)
        result = gapi.get_object('me', fields='friends.limit(2000){id,name,picture.type(large)}')
        result = result.get('friends', {}).get('data', [])
        return self.process_list(result)

    def get_recent(self):
        result = {}
        for perepihon in self.request.user.profile.perepihon_set.all():
            if perepihon.fbid not in result:
                result[perepihon.fbid] = {
                    'fbid': perepihon.fbid,
                    'picture': perepihon.picture,
                    'name': perepihon.name,
                }
        return result

    def get_old(self):
        recent = self.get_recent()
        return list(recent.values()) + [f for f in self.get_friends() if f['fbid'] not in recent]

    def search(self, query):
        gapi = get_fb_connection(self.request.user)
        result = gapi.get_object('search', q=query, type='user', fields='id,name,picture.type(large)')
        result = self.process_list(result.get('data', []))
        old = [f for f in self.get_old() if f['name'].lower().find(query.lower()) != -1]
        fbids = set(f['fbid'] for f in old)
        return old + [f for f in result if f['fbid'] not in fbids]

    def get(self, request, format=None):
        if self.request.query_params.get('q', '') == '':
            return Response(self.get_old())
        return Response(self.search(self.request.query_params['q']))


class PerepihonList(generics.ListCreateAPIView):
    serializer_class = PerepihonSerializer
    permission_classes = (
        permissions.IsAuthenticated,
    )

    def perform_create(self, serializer):
        serializer.save(author=self.request.user.profile)

    def get_queryset(self):
        return Perepihon.objects.filter(author=self.request.user.profile)


class PerepihonDetails(generics.RetrieveUpdateDestroyAPIView):
    serializer_class = PerepihonSerializer
    permission_classes = (
        permissions.IsAuthenticated,
    )

    def perform_update(self, serializer):
        serializer.save(author=self.request.user.profile)

    def get_queryset(self):
        return Perepihon.objects.filter(author=self.request.user.profile)


class DiseaseList(generics.ListAPIView):
    serializer_class = DiseaseSerializer
    permission_classes = (
        permissions.IsAuthenticated,
    )
    queryset = Disease.objects.all()


class CheckList(generics.ListCreateAPIView):
    serializer_class = CheckSerializer
    permission_classes = (
        permissions.IsAuthenticated,
    )

    def perform_create(self, serializer):
        print(self.request.data)
        serializer.save(author=self.request.user.profile)

    def get_queryset(self):
        return Check.objects.filter(author=self.request.user.profile)


class CheckDetails(generics.RetrieveUpdateDestroyAPIView):
    serializer_class = CheckSerializer
    permission_classes = (
        permissions.IsAuthenticated,
    )

    def perform_update(self, serializer):
        serializer.save(author=self.request.user.profile)

    def get_queryset(self):
        return Check.objects.filter(author=self.request.user.profile)


class ProfileDetails(generics.RetrieveAPIView):
    serializer_class = ProfileSerializer
    permission_classes = (
        permissions.IsAuthenticated,
    )

    def get_object(self):
        return self.request.user.profile


class PlayerIDView(generics.UpdateAPIView):
    serializer_class = PlayerIDSerializer
    permission_classes = (
        permissions.IsAuthenticated,
    )

    def get_object(self):
        return self.request.user.profile
