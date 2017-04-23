#!/bin/bash
rm -f app/migrations/0001_initial.py
rm -f db.sqlite3
python3 ./manage.py makemigrations
python3 ./manage.py migrate
python3 ./manage.py loaddata fixtures/init.json
python3 ./manage.py process
#/manage.py dumpdata app auth.user social_django --format=json > fixtures/init.json --indent=4
#echo "from django.contrib.auth.models import User; User.objects.filter(username='ryadom').delete(); User.objects.create_superuser('ryadom', '', 'qweqweqwe')" | python manage.py shell
#python3 ./manage.py importdiseases ./diseases.txt