require 'rubygems'
require 'sinatra'

#requiring the project files
path = File.dirname(__FILE__)
require "#{path}/lib/marketing.rb"

marketing = Marketing.new

get '/:id' do
	json = { :id => "#{params[:id]}" }.to_json
  	optin = marketing.show_optin(json)
	if (!optin.nil?)
		status 200
	 	body "#{optin.to_json}"
	else
		status 404
	 	body "Optin not found, check that you have specified the right ID."
	end
end

post '/create' do
	json = params.to_json
	#we can set the response code at once
	status marketing.new_optin(json)
	case status
		when 200 then body "Optin created successfully."
		when 302 then body "An optin with such company name / channel pair already exists."	
		when 401 then body "Bad request, check your data."
		when 503 then body "Something went wrong during optin creation."
		else body "Unknown error"
	end
end

post '/update' do
	json = params.to_json
	#we can set the response code at once
	status marketing.update_optin(json)
	case status
		when 200 then body "Optin updated successfully"
		when 401 then body "Bad request, check your data."
		when 404 then body "No optin found, check that you have specified the right ID."
		when 503 then body "Something went wrong during optin creation."
		else body "Unknown error"
	end
end

post '/deactivate/:id' do
	json = { :id => "#{params[:id]}" }.to_json
  	status marketing.deactivate_optin(json)
	case status
		when 200 then body "Optin deactivated successfully"
		when 401 then body "Bad request, check your data."
		when 404 then body "No optin found, check that you have specified the right ID."
		when 503 then body "Something went wrong during optin deactivation."
		else body "Unknown error"
	end
end