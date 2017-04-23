#####
# Author: Maria Sandrikova
# Description: Person information about contacts, checks and suspicions
# Copyright 2017
#####

import logging

from .check import DatedProbability

module_logger = logging.getLogger('Person')

# Multiplier when we go futher from the source of disease 
FADING_COEFF = 0.95
CONDOM_COEFF = 0.5

class SpreadPack:

	def __init__(self, person, spread_dict, is_source=False):
		self.person = person
		# {disease_name: List[DatedProbability]}
		self.spread_dict = spread_dict
		self.is_source = is_source


	def activate(self):
		""" 
			Merge diseases came from person with person checks
			We should truncate disease intervals based on persons contacts before
		"""
		updated_spread_dict = dict()
		for disease_name, dated_probability_list in self.spread_dict.items():
			for dated_probability in dated_probability_list:
				if not self.is_source and self.person.is_disease_checked(disease_name, dated_probability):
					# if person has disease then we will spread it directly from him
					# or if he checked that he doesn't ill he cann't spread it futher
					continue
				updated_dated_probabiblity = DatedProbability(
					date=dated_probability.date,
					end_date=dated_probability.end_date, 
					probability=dated_probability.probability * FADING_COEFF
				)
				if disease_name not in updated_spread_dict:
					updated_spread_dict[disease_name] = [updated_dated_probabiblity]
				else:
					updated_spread_dict[disease_name].append(updated_dated_probabiblity)
				if dated_probability.end_date is None \
						or self.person.disease_probabilities[disease_name].date \
						< dated_probability.end_date:
					self.person.disease_probabilities[disease_name].add_probability(
						dated_probability.probability
					)
		return updated_spread_dict


class Person:

	def __init__(self, id, contacts, checks, disease_names):
		# Person's id: string
		self.id = id
		# List of Contacts
		self.contacts = contacts
		# {disease_name: List[Check]}
		self.checks = checks
		# Dict of diseases that this person have, we fill it in calculate_initial_probability()
		self.spread_dict = dict()
		# Dictionary of diseases probabilities
		self.disease_probabilities = {disease_name: DatedProbability() 
			for disease_name in disease_names}
		self.is_ill = False
		# Calculate initial probabilities (.0 or 1.)
		self.calculate_initial_probability()


	def calculate_initial_probability(self):
		for disease_name, check_list in self.checks.items():
			for check in check_list:
				if check.is_positive:
					self.disease_probabilities[disease_name] = DatedProbability(check.date, 1.)
					if disease_name not in self.spread_dict:
						self.spread_dict[disease_name] = [DatedProbability(check.date, 1.)]
					elif self.spread_dict[disease_name][-1].end_date is not None:
						self.spread_dict[disease_name].append(DatedProbability(check.date, 1.))
					self.is_ill = True
				else:
					self.disease_probabilities[disease_name] = DatedProbability(check.date, 0.)
					if disease_name in self.spread_dict:
						self.spread_dict[disease_name][-1].end_date = check.date
			

	def spread_disease(self, persons_dict):
		""" Spread from person all verified diseases he have """
		module_logger.info('Start spreading disease from {}'.format(self.id))                    
		# If person isn't ill do nothing
		if not self.is_ill:
			module_logger.info('Person isn\'t ill')
			return
		visited_persons = set()
		persons_quene = [SpreadPack(self, self.spread_dict, True)]
		# BFS on contacts with fading spread
		while len(persons_quene) > 0:
			spread_pack = persons_quene.pop(0)
			if spread_pack.person.id in visited_persons:
				continue
			module_logger.info('{}: spread pack {}'.format(
				spread_pack.person.id,
				{k: ['s:{} e:{} p:{}'.format(v.date, v.end_date, v.probability) for v in v_list] 
					for k, v_list in spread_pack.spread_dict.items()}
			))
			visited_persons.add(spread_pack.person.id)
			# {disease_name: List[DatedProbability]}
			updated_spread_dict = spread_pack.activate()
			module_logger.info('{}: update spread pack {}'.format(
				spread_pack.person.id,
				{k: ['s:{} e:{} p:{}'.format(v.date, v.end_date, v.probability) for v in v_list] 
					for k, v_list in updated_spread_dict.items()}
			))
			if len(updated_spread_dict) > 0:
				# Otherwise we have nothing to spread
				for contact in spread_pack.person.contacts:
					if contact.partner_id in visited_persons:
						continue
					contact_spread_pack = dict()
					# Truncate update_spread_dict based on contacts between partners
					for disease_name, proba_list in updated_spread_dict.items():
						contact_spread_pack[disease_name] = []
						multiplier = 1.
						if contact.condom_was_used:
							multiplier *= CONDOM_COEFF
						for dated_proba in proba_list:
							new_proba = contact.get_disease_intersection(
								dated_proba, disease_name, multiplier, persons_dict)
							if new_proba is not None:
								contact_spread_pack[disease_name].append(new_proba)
					module_logger.info('{}: contact {} spread pack {}'.format(
						spread_pack.person.id,
						contact.partner_id,
						{k: ['s:{} e:{} p:{}'.format(v.date, v.end_date, v.probability) for v in v_list] 
							for k, v_list in updated_spread_dict.items()}
					))
					persons_quene.append(SpreadPack(
						persons_dict[contact.partner_id],
						contact_spread_pack
					))


	def is_disease_checked(self, disease_name, dated_probability):
		""" Check if disease was checked after given date """
		disease_check_list = self.checks[disease_name]
		for i, check in enumerate(disease_check_list):
			if check.date <= dated_probability.date and check.is_positive and \
					(i + 1 == len(disease_check_list) \
						or dated_probability.date <= disease_check_list[i].date) :
				return True	
		return False


	def get_probabilities(self):
		result_dict = dict()
		for disease, dated_proba in self.disease_probabilities.items():
			result_dict[disease] = dated_proba.probability
		return result_dict


		


