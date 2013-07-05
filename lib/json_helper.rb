class String
	def valid_json?
		JSON.parse(self)  
		return true  
		rescue JSON::ParserError
  			return false
  	end

	def json_to_symbol_hash
		json_hash = JSON.parse(self)
		res = Hash.new
		json_hash.each do |key, value|
			res[key.to_sym] = value
		end
		return res
	end

	def validate_json_with_failure
		if (!self.valid_json?)
			return JsonReply.failure("Bad request", 401)
		end
	end

end

