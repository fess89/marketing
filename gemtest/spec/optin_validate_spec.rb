require 'marketing'

describe Marketing, "#validating_optin" do

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
	end

	it "is created" do
    	optin.class.should eq(Marketing::Optin)
  	end

  	it "validates with good params" do
       	optin.validate(params).should eq(true)
    end

    it "fails to validate without email" do
    	params[:email] = ""
    	optin.validate(params).should eq(false)
    end

    it "fails to validate without company_name" do
    	params[:company_name] = ""
    	optin.validate(params).should eq(false)
    end

    it "fails to validate without first name" do
    	params[:first_name] = ""
    	optin.validate(params).should eq(false)
    end

    it "fails to validate without last name" do
    	params[:last_name] = ""
    	optin.validate(params).should eq(false)
    end

    it "fails to validate with wrong permission_type" do
    	params[:permission_type] = "ololo"
    	optin.validate(params).should eq(false)
    end

    it "fails to validate with wrong channel type" do
    	params[:channel] = "ololo"
    	optin.validate(params).should eq (false)
    end
end