require 'json'

class Marketing
	attr_accessor :db
	def initialize
		@db = SqliteConnector.new
	end

	def show_optin(json_data)
		json_data.validate_json_with_failure
		params = json_data.json_to_symbol_hash
		optin = Optin.find_by_params(@db, { :id => params[:id] })
		if (optin)
			return JsonReply.success("Found optin",
							  optin)
		else
			return JsonReply.failure("Optin not found", 404)
		end		
	end

	def new_optin(json_data)
		json_data.validate_json_with_failure
		params = json_data.json_to_symbol_hash

		#find the optin with given params
		if (!Optin.find_by_params(@db, {:company_name=>params[:company_name],:channel=>params[:channel]}).nil?)	
			#this means duplicate
			return JsonReply.failure("Company #{params[:company_name]} already has an optin for channel type #{params[:channel]}", 
									 302)
		else
			optin = Optin.new(params)
			if optin.save(@db)
				return JsonReply.success("Optin created", nil)
			else
				return JsonReply.failure("Bad request", 401)
			end
		end
	end

	def update_optin(json_data)
		json_data.validate_json_with_failure
		params = json_data.json_to_symbol_hash

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
		json_data.validate_json_with_failure
		params = JSON.parse(json_data)
		id = params["id"]

		#check if there is such an optin
		optin = Optin.find_by_params(@db, { :id => id })
		if (!optin.nil?)
			if optin.deactivate(@db)
				return JsonReply.success("Optin with id #{id} deactivated", nil)
			else
				return JsonReply.failure("Something went wrong during deactivation", 503)
			end
		else
			return JsonReply.failure("Optin with id #{id} not found", 404)
		end
	end
end

path = File.dirname(__FILE__)
require "#{path}/json_reply.rb"
require "#{path}/sqlite_connector.rb"
require "#{path}/optin.rb"
require "#{path}/json_helper.rb"
