require 'json'

class Marketing
	attr_accessor :db

	# Initializes with the instance variable @db as a new SqliteConnector
	def initialize
		@db = SqliteConnector.new
	end

	# Shows an optin
	# Params:
	# +json_data:: a JSON string containing parameters
	# Currently supports only { :id => id }, other key-value pairs will be silently ignored
	# Support for other parameters may be added later
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

	# Creates an optin
	# Params:
	# +json_data:: a JSON string containing parameters
	# Validates JSON and returns 401 Bad Request if it is invalid
	# Before creating, tries to find duplicates in DB (by company name && channel)
	# Returns:
	# * 302 Found if there is a duplicate
	# * 200 OK if optin is created
	# * 401 Bad Request if optin is not saved for some reason
	def new_optin(json_data)
		json_data.validate_json_with_failure
		params = json_data.json_to_symbol_hash

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

	# Updates an optin with new data
	# Params:
	# +json_data:: a JSON string containing parameters
	# Example: { :id => 4, :company_name => "Oracle", :channel => "sms" }
	# Validates JSON and returns 401 Bad Request if it is invalid
	# Before updating, checks if an optin with the given ID is present
	# Returns:
	# * 200 OK if the update is successful
	# * 404 Not Found if there is no optin with the given ID
	# * 503 Internal Server Error if update does not succeed
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

	# Deletes an optin from the database
	# Params:
	# +json_data:: a JSON string containing parameters
	# Currently supports only { :id => id }, other key-value pairs will be silently ignored
	# Validates JSON and returns 401 Bad Request if it is invalid
	# * 200 OK if the update is successful
	# * 404 Not Found if there is no optin with the given ID
	# * 503 Internal Server Error if deactivation does not succeed
	def deactivate_optin(json_data)
		json_data.validate_json_with_failure
		params = json_data.json_to_symbol_hash

		optin = Optin.find_by_params(@db, { :id => params[:id] })
		if (!optin.nil?)
			if optin.deactivate(@db)
				return JsonReply.success("Optin with id #{params[:id]} deactivated", nil)
			else
				return JsonReply.failure("Something went wrong during deactivation", 503)
			end
		else
			return JsonReply.failure("Optin with id #{params[:id]} not found", 404)
		end
	end
end

path = File.dirname(__FILE__)
require "#{path}/json_reply.rb"
require "#{path}/sqlite_connector.rb"
require "#{path}/optin.rb"
require "#{path}/json_helper.rb"