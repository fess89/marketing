require "#{Dir.pwd}/lib/marketing.rb"

describe Marketing, "#optin_validation" do

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
        puts
	end

	it "is created with class Optin" do
        optin = Marketing::Optin.new(params)
    	optin.class.should eq(Marketing::Optin)
  	end

  	it "validates with good params" do
        optin = Marketing::Optin.new(params)
       	optin.valid?.should eq(true)
    end

    it "fails to validate without email" do
    	params[:email] = ""
        optin = Marketing::Optin.new(params)
    	optin.valid?.should eq(false)
    end

    it "fails to validate without company_name" do
    	params[:company_name] = ""
        optin = Marketing::Optin.new(params)
    	optin.valid?.should eq(false)
    end

    it "fails to validate without first name" do
    	params[:first_name] = ""
        optin = Marketing::Optin.new(params)
    	optin.valid?.should eq(false)
    end

    it "fails to validate without last name" do
    	params[:last_name] = ""
        optin = Marketing::Optin.new(params)
    	optin.valid?.should eq(false)
    end

    it "fails to validate with wrong permission_type" do
    	params[:permission_type] = "ololo"
        optin = Marketing::Optin.new(params)
    	optin.valid?.should eq(false)
    end

    it "fails to validate with wrong channel type" do
    	params[:channel] = "ololo"
        optin = Marketing::Optin.new(params)
    	optin.valid?.should eq(false)
    end
end