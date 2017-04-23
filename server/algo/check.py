#####
# Author: Maria Sandrikova
# Description: Information about checking
# Copyright 2017
#####


class Check:

	def __init__(self, date, is_positive):
		# Date of check
		self.date = date
		# Boolean
		self.is_positive = is_positive


class DatedProbability:

	def __init__(self, date=None, probability=.0):
		# Date of check from which we get probability
		# or None if we have no signal about that disease
		self.date = date
		# Date when person verified that he hasn't this disease
		self.end_date = None
		# Probability
		self.probability = probability


	def add_probability(self, addition):
		self.probability = self.probability + addition - self.probability * addition
