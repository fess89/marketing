require 'json'
require 'net/http'

class Marketing::JsonReply
	def self.success(message, object=nil)
		if (object)
			json_data = object.to_json
			hash = JSON.parse(json_data)
		else
			hash = Hash.new
		end		
		hash[:message] = message
		res = Net::HTTPResponse.new(1.1, 200, hash.to_json)
		return res
	end

	def self.failure(message=nil, code=503)
		res = Net::HTTPResponse.new(1.1, code, message)
		return res
	end
end