from django.core.management.base import BaseCommand, CommandError

from algo import Contact, Person, Runner
from algo import Check as MCheck
from app.models import *
from config import settings
import requests
import json

class Command(BaseCommand):
    help = 'Process diseases'

    def get_score(self, fbid, did):
        profile = Profile.objects.get(fbid=fbid)
        disease = Disease.objects.get(id=did)
        return Score.objects.get_or_create(disease=disease, user=profile)[0]

    def notificate(self, users):
        header = {"Content-Type": "application/json; charset=utf-8",
                  "Authorization": "Basic ZDczNzM1MGYtOWVmYi00Y2E1LWI3OTEtZjMwZmNhMjNhNjU4"}
        payload = {"app_id": "260ccee5-d5b0-422a-8192-d85e8be40b57",
                   "include_player_ids": [u.playerid for u in users if u.playerid != '' and u.playerid is not None],
                   "contents": {"en": "You have some updates"}}
        print(payload)
        req = requests.post("https://onesignal.com/api/v1/notifications", headers=header, data=json.dumps(payload))
        print(req.status_code, req.reason)

    def handle(self, *args, **options):
        #self.notificate(Profile.objects.all())
        #return
        graph = {}
        for perepihon in Perepihon.objects.all():
            graph.setdefault(perepihon.author.fbid, [])
            graph.setdefault(perepihon.fbid, [])
            graph[perepihon.author.fbid].append(Contact(perepihon.fbid,
                                                        perepihon.start,
                                                        perepihon.end,
                                                        perepihon.condom))
            graph[perepihon.fbid].append(Contact(perepihon.author.fbid,
                                                 perepihon.start,
                                                 perepihon.end,
                                                 perepihon.condom))
        for k, v in graph.items():
            v.sort(key=lambda x: x.start_date)
        diseases = [d.id for d in Disease.objects.all()]
        checks = {}
        for check in Check.objects.all():
            if check.author.fbid not in checks:
                checks[check.author.fbid] = {d: [] for d in diseases}
            for d in check.diseases.all():
                checks[check.author.fbid][d.id].append(MCheck(check.date, not check.is_clean))
        print(graph)
        print(checks)
        persons = []
        for k, v in graph.items():
            persons.append(Person(k, v, checks[k] if k in checks else {d: [] for d in diseases}, diseases))
        result = Runner(persons).get_probabilities()
        notifications = set()
        for pid, v in result.items():
            for dis, val in v.items():
                score = self.get_score(pid, dis)
                if (score.score < settings.RED_LEVEL <= val) or (val < settings.RED_LEVEL <= score.score):
                    notifications.add(pid)
                score.score = val
                score.save()
        users = [u for u in Profile.objects.all() if u.fbid in notifications]
        self.notificate(users)
        print('Done')
