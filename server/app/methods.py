
from .models import *

import facebook
facebook.VALID_API_VERSIONS.append('2.9')


def get_token(user):
    return (user.social_auth.get(provider='facebook').
            extra_data['access_token'])


def get_fb_id(user):
    return (user.social_auth.get(provider='facebook').
            extra_data['id'])


def get_fb_connection(user):
    return facebook.GraphAPI(access_token=get_token(user),
                             version='2.9')

def prepare_user(user):
    profile, created = Profile.objects.get_or_create(user=user)
    if created:
        profile.fbid = get_fb_id(user)
        profile.picture = get_fb_connection(user).get_object(
                'me/picture', height=100)['url']
        profile.save()