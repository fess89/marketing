require "#{Dir.pwd}/lib/marketing.rb"
require 'spec_helper'

describe Marketing, "#optin_crud" do

	marketing = Marketing.new
	params = Hash.new
	optin = nil
	before :each do
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

    it "gets saved" do
    	optin.save(marketing.db)
		expect(marketing.db.changes).to eq(1)
	end

	it "returns JSON with code 302 if company already has an optin for this channel" do
		#company name is now random
		cname  = (0...8).map{(65+rand(26)).chr}.join
		params[:company_name] = cname

		#first time we save it, the optin should get saved
		response = marketing.new_optin(params.to_json)
		response.code.should eq(200)

		#but second time there is a duplicate so we get 302
		response = marketing.new_optin(params.to_json)
		response.code.should eq(302)
	end

	it "returns JSON with code 200 if updating existing optin" do
		rand  = (0...8).map{(65+rand(26)).chr}.join
		params[:first_name] = rand
		params[:id] = (marketing.db.execute "select id from optins order by id desc limit 1").flatten[0]
		response = marketing.update_optin(params.to_json)
		response.code.should eq(200)
	end

	it "returns JSON with code 200 if deactivating existing optin" do
		#finding max id
		max_id = (marketing.db.execute "select id from optins order by id desc limit 1").flatten[0]
		response = marketing.deactivate_optin({:id => max_id}.to_json)
		response.code.should eq(200)
	end

	it "returns JSON with code 404 if deactivating nonexistent optin" do
		#this probably does not exist
		id = (marketing.db.execute "select id from optins order by id desc limit 1").flatten[0] + rand(1000)
		response = marketing.deactivate_optin({:id => id}.to_json)
		response.code.should eq(404)
	end

	it "returns JSON with code 200 if viewing existing optin" do
		max_id = (marketing.db.execute "select id from optins order by id desc limit 1").flatten[0]
		response = marketing.show_optin({:id => max_id}.to_json)
		response.message.valid_json?.should eq(true)
		response.code.should eq(200)
	end

	it "returns JSON with code 404 if viewing nonexistent optin" do
		max_id = (marketing.db.execute "select id from optins order by id desc limit 1").flatten[0] + rand(1000)
		response = marketing.show_optin({:id => max_id}.to_json)
		response.code.should eq(404)
	end
end
