require 'json'
require 'json_reply'

class String

	# Checks if a string is valid JSON
	def valid_json?
		JSON.parse(self)  
		return true  
		rescue JSON::ParserError
  			return false
  	end

  	# Converts a string to a hash with symbol keys
	def json_to_symbol_hash
		json_hash = JSON.parse(self)
		res = Hash.new
		json_hash.each do |key, value|
			res[key.to_sym] = value
		end
		return res
	end

	# Checks if a string is valid JSON
	# If not, replies with a 401 Bad Request HTTP Response
	def validate_json_with_failure
		if (!self.valid_json?)
			return JsonReply.failure("Bad request", 401)
		end
	end

end

