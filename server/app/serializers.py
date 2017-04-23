from rest_framework import serializers
from .models import *
from config import settings


class PerepihonSerializer(serializers.ModelSerializer):
    class Meta:
        model = Perepihon
        fields = ('name', 'fbid', 'picture', 'start', 'end', 'id', 'condom')


class DiseaseSerializer(serializers.ModelSerializer):
    class Meta:
        model = Disease
        fields = ('id', 'name', 'url')


class CheckSerializer(serializers.ModelSerializer):
    class Meta:
        model = Check
        fields = ('id', 'diseases', 'date', 'is_clean')


class ScoreSerializer(serializers.ModelSerializer):
    disease = DiseaseSerializer()
    color = serializers.SerializerMethodField()

    def get_color(self, obj):
        return obj.get_color()

    class Meta:
        model = Score
        fields = ('disease', 'score', 'color')


class ProfileSerializer(serializers.ModelSerializer):
    scores = serializers.SerializerMethodField()
    name = serializers.SerializerMethodField()
    color = serializers.SerializerMethodField()

    def get_scores(self, obj):
        scores = obj.scores.order_by('-score')
        return (ScoreSerializer(many=True, **{'context': self.context}).
                to_representation(scores))

    def get_color(self, obj):
        return max([score.get_color() for score in obj.scores.all()] + [0])

    def get_name(self, obj):
        return '{} {}'.format(obj.user.first_name, obj.user.last_name)

    class Meta:
        model = Profile
        fields = ('fbid', 'picture', 'scores', 'name', 'color')


class PlayerIDSerializer(serializers.ModelSerializer):
    class Meta:
        model = Profile
        fields = ('playerid', )