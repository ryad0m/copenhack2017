#####
# Author: Maria Sandrikova
# Description: General tests for algorithm
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
        probabilitites = runner.get_probabilities()
        self.save_in_file(probabilitites, 'simple_chain.txt')
        self.assertTrue(probabilitites['Alex']['AIDS'] > .5)


    def test_condom_use(self):
        persons = []
        persons.append(Person(
            'Helen',
            [
                Contact('Max', date(2016, 1, 24), condom_was_used=True)
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
                Contact('Helen', date(2016, 1, 24), condom_was_used=True),
            ],
            {
                'AIDS': [], 'Gonorrhea': [], 'HIV': []
            },
            DISEASES_NAMES
        ))
        runner = Runner(persons)
        probabilitites = runner.get_probabilities()
        self.save_in_file(probabilitites, 'test_condom_use.txt')
        self.assertTrue(probabilitites['Max']['AIDS'] < .5)
        self.assertTrue(probabilitites['Max']['AIDS'] > .2)


    def test_negative_check(self):
        persons = []
        persons.append(Person(
            'Helen',
            [
                Contact('Max', date(2016, 1, 24), condom_was_used=False)
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
                Contact('Helen', date(2016, 1, 24), condom_was_used=False),
            ],
            {
                'AIDS': [Check(date(2016, 2, 12), False)], 
                'Gonorrhea': [], 'HIV': []
            },
            DISEASES_NAMES
        ))
        runner = Runner(persons)
        probabilitites = runner.get_probabilities()
        self.save_in_file(probabilitites, 'test_negative_check.txt')
        self.assertTrue(probabilitites['Max']['AIDS'] == .0)


    def test_empty_intersection(self):
        persons = []
        persons.append(Person(
            'Helen',
            [
                Contact('Max', date(2016, 1, 24), condom_was_used=False)
            ],
            {
                'AIDS': [Check(date(2016, 1, 13), True), Check(date(2016, 1, 15), True)],
                'Gonorrhea': [], 'HIV': []
            },
            DISEASES_NAMES
        ))
        persons.append(Person(
            'Max',
            [
                Contact('Helen', date(2016, 1, 24), condom_was_used=False),
            ],
            {
                'AIDS': [], 'Gonorrhea': [], 'HIV': []
            },
            DISEASES_NAMES
        ))
        runner = Runner(persons)
        probabilitites = runner.get_probabilities()
        self.save_in_file(probabilitites, 'test_empty_intersection.txt')
        self.assertTrue(probabilitites['Max']['AIDS'] == .0)






        