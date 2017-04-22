from django.db import models

from django.db import models
from django.contrib.auth.models import User


class Profile(models.Model):
    user = models.OneToOneField(User)
    fbid = models.CharField(max_length=63)
    picture = models.URLField(max_length=255, null=True, blank=True)

    def __str__(self):
        return 'Profile ' + str(self.user.id)


class Perepihon(models.Model):
    author = models.ForeignKey(Profile)
    name = models.CharField(max_length=63)
    fbid = models.CharField(max_length=100)
    picture = models.URLField(max_length=255, null=True, blank=True)
    start = models.DateField()
    end = models.DateField(null=True)


class Disease(models.Model):
    name = models.CharField(max_length=100)
    url = models.URLField(max_length=255)

    def __str__(self):
        return self.name


class Check(models.Model):
    pass
