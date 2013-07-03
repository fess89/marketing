require 'json'

class Marketing::JsonReply
	def self.success(message, object=nil)
		if (object)
			json_data = object.to_json
			hash = JSON.parse(json_data)
		else
			hash = Hash.new
		end		
		hash[:message] = message
		hash[:code] = 200
		return hash.to_json
	end

	def self.failure(message=nil, code=503)
		data = Hash.new
		data[:code] = code
		data[:message] = message
		return data.to_json
	end
end