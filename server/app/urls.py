from django.conf.urls import url, include

from . import views

urlpatterns = [
    url(r'^search/$', views.SearchView.as_view(), name='search_view'),
    url(r'^connections/$', views.PerepihonList.as_view(), name='perepihon_list'),
    url(r'^connections/(?P<pk>[0-9]+)/$', views.PerepihonDetails.as_view(), name='perepihon_details'),
    url(r'^checks/$', views.CheckList.as_view(), name='check_list'),
    url(r'^checks/(?P<pk>[0-9]+)/$', views.CheckDetails.as_view(), name='check_details'),
    url(r'^diseases/$', views.DiseaseList.as_view(), name='disease_list'),
    url(r'me/', views.ProfileDetails.as_view(), name='profile_details'),
    url(r'playerid/', views.PlayerIDView.as_view(), name='playerid_details'),
]