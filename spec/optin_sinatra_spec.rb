require "#{Dir.pwd}/marketing_sinatra.rb"
require 'rack/test'
require 'sinatra'

def app
	Sinatra::Application
end

describe Marketing, "#sinatra_optin_crud" do

	include Rack::Test::Methods

	marketing = Marketing.new
	optin = nil
	params = Hash.new

	before :each do
		params = Hash.new
	    params[:email] = "chyrkov@kth.se"
	    params[:mobile] = "380632721593"
	    params[:company_name] = "Apple"
	    params[:first_name] = "Oleksii"
	    params[:last_name] = "Chyrkov"
	    params[:permission_type] = "one-time"
	    params[:channel] = "sms"
	   	optin = Marketing::Optin.new(params)
	   	puts
	end

	it "returns code 200 if viewing existing optin" do
		max_id = (marketing.db.execute "select id from optins order by id desc limit 1").flatten[0]
		get "/#{max_id}"
		last_response.should be_ok
	end

 	it "returns code 200 if updating existing optin" do
 		rand  = (0...8).map{(65+rand(26)).chr}.join
 		params[:first_name] = rand
 		params[:id] = (marketing.db.execute "select id from optins order by id desc limit 1").flatten[0]
 		
		post "/update", params
		last_response.should be_ok		
 	end

 	it "returns code 200 if deactivating existing optin" do
 		#finding max id
 		max_id = (marketing.db.execute "select id from optins order by id desc limit 1").flatten[0]
 		post "/deactivate/#{max_id}"
 		last_response.should be_ok
 	end

 	it "returns code 302 if company already has an optin for this channel on creation" do
 		#company name is now random
 		cname  = (0...8).map{(65+rand(26)).chr}.join
 		params[:company_name] = cname

 		#first time we save it, the optin should get saved
 		post "/create", params
 		last_response.should be_ok

 		#but second time there is a duplicate so we get 302
 		post "/create", params
 		last_response.status.should eq(302)
 	end

 	 it "returns code 302 if company already has an optin for this channel on update" do
 	 	params[:id] = (marketing.db.execute "select id from optins order by id desc limit 1").flatten[0] - 2
 	 	params[:company_name] = (marketing.db.execute "select company_name from optins order by id desc limit 1").flatten[0]
	 	params[:channel] = (marketing.db.execute "select channel from optins order by id desc limit 1").flatten[0] 	 	
 		
 		post "/update", params
 		last_response.status.should eq(302)
 	end

 	it "returns code 401 if creating from invalid JSON" do
 		params = (0...100).map{(65+rand(26)).chr}.join
 		post "/create", params
 		last_response.status.should eq(401)
 	end

 	it "returns code 401 if updating from invalid JSON" do
 		params = (0...100).map{(65+rand(26)).chr}.join
 		post "/create", params
 		last_response.status.should eq(401)
 	end

	it "returns code 404 if viewing nonexistent optin" do
 		max_id = (marketing.db.execute "select id from optins order by id desc limit 1").flatten[0] + rand(1000)
 		get "/#{max_id}"
		last_response.status.should eq(404)
 	end

 	it "returns code 404 if deactivating nonexistent optin" do
 		#this probably does not exist
 		id = (marketing.db.execute "select id from optins order by id desc limit 1").flatten[0] + rand(1000)
 		post "/deactivate/#{id}"
 		last_response.status.should eq(404)
 	end

end
