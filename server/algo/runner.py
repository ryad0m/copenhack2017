#####
# Author: Maria Sandrikova
# Description: Algorithm runner 
# Copyright 2017
#####

import logging

module_logger = logging.getLogger('Runner')


class Runner:

	def __init__(self, persons):
		""" 
			diseases: list[Disease] 
			persons: list[Person]
		"""
		module_logger.info('Receive {} persons'.format(len(persons)))
		self.persons = persons
		self.run()


	def get_probabilities(self):
		""" return {person_id: {disease_name: probability}} """
		result_dict = dict()
		return {person.id: person.get_probabilities() for person in self.persons}


	def run(self):
		""" Try to spread disease from every ill person """
		persons_dict = {person.id: person for person in self.persons}
		for person in self.persons:
			person.spread_disease(persons_dict)
