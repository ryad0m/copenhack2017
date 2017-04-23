#####
# Author: Maria Sandrikova
# Description: Information about contact
# Copyright 2017
#####


class Contact:

	def __init__(self, partner_id, start_date, 
			end_date=None, condom_was_used=False):
		# Partner's id
		self.parnter_id = partner_id
		# Start of relationship
		self.start_date = start_date
		# End of relationship
		# If it was once contact then set end_date = start_date
		# If relationship is continuing in the present set end_date = None
		self.end_date = end_date
		# Boolean
		self.condom_was_used = condom_was_used
