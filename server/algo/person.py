#####
# Author: Maria Sandrikova
# Description: Person information about contacts, checks and suspicions
# Copyright 2017
#####

from .check import DatedProbability

# Multiplier when we go futher from the source of disease 
FADING_COEFF = 0.95


class SpreadPack:

	def __init__(self, person, spread_dict):
		self.person = person
		# {disease_name: List[DatedProbability]}
		self.spread_dict = spread_dict


	def activate():
		""" 
			Merge diseases came from person with person checks
			We should truncate disease intervals based on persons contacts before
		"""
		updated_spread_dict = dict()
		for disease_name, dated_probability_list in self.spread_dict.items():
			for dated_probability in dated_probability_list:
				if self.person.is_disease_checked(disease_name, dated_probability):
					# if person has disease then we will spread it directly from him
					# or if he checked that he doesn't ill he cann't spread it futher
					continue
				updated_dated_probabiblity = DatedProbability(
					dated_probability.date, 
					dated_probability.dated_probability * FADING_COEFF
				)
				if disease_name not in updated_spread_dict:
					updated_spread_dict[disease_name] = updated_dated_probabiblity
				else:
					updated_spread_dict[disease_name].append(updated_dated_probabiblity)
				if person.disease_probabilities[disease_name].date < dated_probability.end_date:
					person.disease_probabilities[disease_name].add_probability(
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
					elif self.spread_dict[disease_name].end_date is not None:
						self.spread_dict[disease_name].append(DatedProbability(check.date, 1.))
					self.is_ill = True
				else:
					self.disease_probabilities[disease_name] = DatedProbability(check.date, 0.)
					if disease_name in self.spread_dict:
						self.spread_dict[spread_name].last().end_date = check.date
			

	def spread_disease(self, persons_dict):
		""" Spread from person all verified diseases he have """
		# If person isn't ill do nothing
		if not self.is_ill:
			return
		visited_persons = {self.id}
		persons_quene = [SpreadPack(self, self.spread_dict)]
		# BFS on contacts with fading spread
		while len(persons_quene) > 0:
			spread_pack = persons_quene.pop(0)
			if spread_pack.person.id in visited_persons:
				continue
			visited_persons.add(spread_pack.person.id)
			updated_spread_dict = spread_pack.activate()
			if len(updated_spread_dict) > 0:
				# Otherwise we have nothing to spread
				for contact in self.person.contacts:
					if contact.partner_id in visited_persons:
						continue
					# TODO: truncate update_spread_dict based on person's contacts
					# TODO: check if condom was used
					persons_quene.append(SpreadPack(
						persons_dict[contact.partner_id],
						update_spread_dict
					))


	def is_disease_checked(self, disease_name, dated_probability):
		""" Check if disease was checked after given date """
		disease_check_list = self.checks[disease_name]
		for check in disease_check_list:
			if check.date <= date and \
					(check.end_date is None or date <= check.end_date) :
				return True	
		return False


		


