require 'json'

class Marketing
	attr_accessor :db
	def initialize
		@db = SqliteConnector.new
	end

	def show_optin(json_data)
		if (!json_data.valid_json?)
			return JsonReply.failure("Bad request", 401)
		end
		json_hash = JSON.parse(json_data)
		params = Hash.new
		json_hash.each do |key, value|
			params[key.to_sym] = value
		end
		optin = Optin.find_by_params(@db, { :id => params[:id] })
		if (optin)
			return JsonReply.success("Found optin",
							  optin)
		else
			return JsonReply.failure("Optin not found", 404)
		end		
	end

	def new_optin(json_data)
		if (!json_data.valid_json?)
			return JsonReply.failure("Bad request", 401)
		end
		json_hash = JSON.parse(json_data)
		params = Hash.new
		json_hash.each do |key, value|
			params[key.to_sym] = value
		end
		optin = Optin.new(params)

		#find the optin with given params
		res = Optin.find_by_params(@db, { :company_name => optin.company_name, 
								     	  :channel => optin.channel} )	
		if (res != nil)
			#this means duplicate
			return JsonReply.failure("Company #{optin.company_name} already has an optin for channel type #{optin.channel}", 
									 302)
		else
			if optin.save(@db)
				return JsonReply.success("Optin created", nil)
			else
				return JsonReply.failure("Bad request", 401)
			end
		end
	end

	def update_optin(json_data)
		if (!json_data.valid_json?)
			return JsonReply.failure("Bad request", 401)
		end
		json = JSON.parse(json_data)
		params = Hash.new
		json.each do |key, value|
			params[key.to_sym] = value
		end
		#check if there is an optin with the given id
		optin = Optin.find_by_params(@db, { :id => params[:id] })
		if (optin)
			if optin.update(@db, params)
				return JsonReply.success("Optin with id #{params[:id]} deactivated", nil)
			else
				return JsonReply.failure("Something went wrong during update", 503)
			end
		else
			return JsonReply.failure("Optin with id #{params[:id]} not found", 404)
		end
	end

	def deactivate_optin(json_data)
		if (!json_data.valid_json?)
			return JsonReply.failure("Bad request", 401)
		end
		params = JSON.parse(json_data)
		id = params["id"]
		#check if there is such an optin
		optin = Optin.find_by_params(@db, { :id => id })
		if (optin)
			#success
			if optin.deactivate(@db)
				return JsonReply.success("Optin with id #{id} deactivated", nil)
			else
				return JsonReply.failure("Something went wrong during deactivation", 503)
			end
		else
			return JsonReply.failure("Optin with id #{id} not found", 404)
		end
	else
end

end

path = File.dirname(__FILE__)
require "#{path}/json_reply.rb"
require "#{path}/sqlite_connector.rb"
require "#{path}/optin.rb"
