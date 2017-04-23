#####
# Author: Maria Sandrikova
# Description: Information about contact
# Copyright 2017
#####

from .check import DatedProbability


class Contact:

	def __init__(self, partner_id, start_date, 
			end_date=None, condom_was_used=False):
		# Partner's id
		self.partner_id = partner_id
		# Start of relationship
		self.start_date = start_date
		# End of relationship
		# If it was once contact then set end_date = start_date
		# If relationship is continuing in the present set end_date = None
		self.end_date = end_date
		# Boolean
		self.condom_was_used = condom_was_used


	def get_disease_intersection(self, 
			dated_probability, disease_name, multiplier, partners_dict):
		new_probability = None
		if dated_probability.end_date is None or \
				dated_probability.end_date > self.start_date:
			new_probability = DatedProbability(
				date=self.start_date,
				end_date=None,
				probability=dated_probability.probability * multiplier
			)
			# Add end_date based on self.partner_id last check
			partner = partners_dict[self.partner_id]
			for check in partner.checks[disease_name]:
				if check.date > new_probability.date and not check.is_positive:
					new_probability.end_date = check.date
					break
		return new_probability
