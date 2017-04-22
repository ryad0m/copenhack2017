#####
# Author: Maria Sandrikova
# Copyright 2017
#####

import unittest
import os
from datetime import date

from algo import Runner, Person, Contact, Check

WORKING_DIR = os.path.dirname(__file__)
OUTPUT_DIR = os.path.join(WORKING_DIR, 'output')

DISEASES_NAMES = ['AIDS', 'Gonorrhea', 'HIV']


class GeneralTestSuite(unittest.TestCase):
    """ Tests for algo.Runner class """

    def save_in_file(self, probabilitites, filename):
        with open(os.path.join(OUTPUT_DIR, filename), 'w', encoding='utf8') as f:
            for person, prob_dict in probabilitites.items():
                f.write(person + '\n')
                for disease, proba in prob_dict.items():
                    f.write('\t{}: {}\n'.format(disease, proba))


    def setUp(self):
        if not os.path.exists(OUTPUT_DIR):
            os.makedirs(OUTPUT_DIR)


    def test_simple_chain(self):
        persons = []
        persons.append(Person(
            'Helen',
            [
                Contact('Max', date(2016, 1, 24))
            ],
            {
                'AIDS': [Check(date(2016, 2, 10), True)],
                'Gonorrhea': [], 'HIV': []
            },
            DISEASES_NAMES
        ))
        persons.append(Person(
            'Max',
            [
                Contact('Helen', date(2016, 1, 24)),
                Contact('Sara', date(2016, 1, 25))
            ],
            {
                'AIDS': [], 'Gonorrhea': [], 'HIV': []
            },
            DISEASES_NAMES
        ))
        persons.append(Person(
            'Sara',
            [
                Contact('Max', date(2016, 1, 25)),
                Contact('Alex', date(2016, 1, 26))
            ],
            {
                'AIDS': [], 'Gonorrhea': [], 'HIV': []
            },
            DISEASES_NAMES
        ))
        persons.append(Person(
            'Alex',
            [
                Contact('Sara', date(2016, 1, 26))
            ],
            {
                'AIDS': [], 'Gonorrhea': [], 'HIV': []
            },
            DISEASES_NAMES
        ))
        runner = Runner(persons)
        runner.run()
        self.save_in_file(runner.get_probabilities(), 'simple_chain.txt')






        