require 'json'
require 'net/http'

class Marketing::JsonReply

	def self.success(message, object=nil)
		#so many conversions because we are adding the message
		if (object)
			hash = JSON.parse(object.to_json)
		else
			hash = Hash.new
		end		
		hash[:message] = message
		return Net::HTTPResponse.new(1.1, 200, hash.to_json)
	end

	def self.failure(message=nil, code=503)
		return Net::HTTPResponse.new(1.1, code, message)
	end
end