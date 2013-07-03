#all methods will return 200 and JSON on success and JSON with error on failure

class Marketing
	attr_accessor :db
	def initialize
		@db = SqliteConnector.new
	end

	def show_optin(id)
		optin = Optin.find_by_params(@db, { :id => id })
		if (optin)
			JsonReply.success("Found optin with id #{id}",
							  optin)
		else
			JsonReply.failure("Optin not found", 404)
		end		
	end

	def new_optin(json_data)
		json = JSON.parse(json_data)
		params = Hash.new
		json.each do |key, value|
			params[key.to_sym] = value
		end
		#validation is inside the Optin class
		optin = Optin.new(params)
		#find the optin with given params
		if (Optin.find_by_params(@db, { :company_name => optin.company_name, 
								     	:channel => optin.channel} ))		
			#this means duplicate
			return JsonReply.failure("Company #{optin.company_name} already has an optin for channel type #{optin.channel}", 
									 302)
		else
			if optin.save(@db)
				return JsonReply.success("Optin created", optin)
			else
				return JsonReply.failure("Something went wrong during creation", 503)
			end
		end
	end

	def update_optin(json_data)
		json = JSON.parse(json_data)
		params = Hash.new
		json.each do |key, value|
			params[key.to_sym] = value
		end
		#check if there is an optin with the given id
		optin = Optin.find_by_params(@db, { :id => params[:id] })
		if (optin)
			if optin.update(@db, params)
				return JsonReply.success("Optin with id #{params[:id]} deactivated", optin)
			else
				return JsonReply.failure("Something went wrong during update", 503)
			end
		else
			return JsonReply.failure("Optin with id #{params[:id]} not found", 404)
		end
	end

	def deactivate_optin(json_data)
		if (json_data)
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

end

require 'marketing/json_reply'
require 'marketing/optin'
require 'marketing/sqlite_connector'