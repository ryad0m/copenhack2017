from django.core.management.base import BaseCommand, CommandError
from app.models import Disease


class Command(BaseCommand):
    help = 'Import diseases'

    def add_arguments(self, parser):
        parser.add_argument('filename', nargs='+', type=str)

    def handle(self, *args, **options):
        for r in open(options['filename'][0], 'r').readlines():
            name, url = r.strip().split('_')
            Disease.objects.create(name=name, url=url)
        print('Done')
