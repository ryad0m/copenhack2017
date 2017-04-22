from rest_framework import serializers
from .models import *


class PerepihonSerializer(serializers.ModelSerializer):
    class Meta:
        model = Perepihon
        fields = ('name', 'fbid', 'picture', 'start', 'end', 'id')


class DiseaseSerializer(serializers.ModelSerializer):
    class Meta:
        model = Disease
        fields = ('id', 'name', 'url')
