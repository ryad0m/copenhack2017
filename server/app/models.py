from django.db import models

from django.db import models
from django.contrib.auth.models import User
from config import settings


class Profile(models.Model):
    user = models.OneToOneField(User)
    fbid = models.CharField(max_length=63)
    picture = models.URLField(max_length=255, null=True, blank=True)
    playerid = models.CharField(max_length=63, null=True, blank=True)

    def __str__(self):
        return '[{}] {}'.format(self.fbid, self.user.username)


class Disease(models.Model):
    name = models.CharField(max_length=100)
    url = models.URLField(max_length=255)

    def __str__(self):
        return self.name


class Score(models.Model):
    user = models.ForeignKey(Profile, related_name='scores')
    disease = models.ForeignKey(Disease)
    score = models.FloatField(default=0.0)

    def get_color(self):
        if settings.RED_LEVEL <= self.score:
            return 2
        elif settings.YELLOW_LEVEL <= self.score:
            return 1
        return 0

    def __str__(self):
        return '{} {} - {}'.format(self.user, self.disease, self.score)


class Perepihon(models.Model):
    author = models.ForeignKey(Profile)
    name = models.CharField(max_length=63)
    fbid = models.CharField(max_length=100)
    picture = models.URLField(max_length=255, null=True, blank=True)
    start = models.DateField()
    end = models.DateField(null=True, blank=True)
    condom = models.BooleanField()

    def __str__(self):
        return '{} -> {}'.format(self.author, self.fbid)


class Check(models.Model):
    author = models.ForeignKey(Profile)
    diseases = models.ManyToManyField(Disease, blank=True)
    date = models.DateField()
    is_clean = models.BooleanField()

    def __str__(self):
        return '{} {} {}'.format(self.author, self.diseases, self.is_clean)
