require 'marketing'

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
	end

    it "gets saved" do
    	optin.save(marketing.db)
		expect(marketing.db.changes).to eq(1)
	end

	it "does not get saved from JSON if company already has an optin for this channel" do
		#company name is now random
		cname  = (0...8).map{(65+rand(26)).chr}.join
		params[:company_name] = cname
		#first time we save it, the optin should get saved
		expect ((JSON.parse(marketing.new_optin(params.to_json)))["code"]).should eq(200)
		#but second time there is a duplicate so we get nil
		expect ((JSON.parse(marketing.new_optin(params.to_json)))["code"]).should_not eq(200)
	end

	it "gets updated from JSON if an optin with the given ID exists" do
		rand  = (0...8).map{(65+rand(26)).chr}.join
		params[:first_name] = rand
		params[:id] = (marketing.db.execute "select id from optins order by id desc limit 1").flatten[0]
		expect ((JSON.parse(marketing.update_optin(params.to_json)))["code"]).should eq(200)
	end

	it "can be deactivated from JSON if exists" do
		#finding max id
		p "Deactivating if exists"
		max_id = (marketing.db.execute "select id from optins order by id desc limit 1").flatten[0]
		expect (JSON.parse(marketing.deactivate_optin({:id => max_id}.to_json)))["code"].should eq(200)
	end

	it "cannot be deactivated from JSON if it does not exist" do
		p "Deactivating if does not exist"
		#this probably does not exist
		id = (marketing.db.execute "select id from optins order by id desc limit 1").flatten[0] + 38000
		expect (JSON.parse(marketing.deactivate_optin({:id => id}.to_json)))["code"].should_not eq(200)
	end

	it "can be viewed as JSON if it exists" do
		max_id = (marketing.db.execute "select id from optins order by id desc limit 1").flatten[0]
		expect ((JSON.parse(marketing.show_optin(max_id)))["code"]).should eq(200)
	end

	it "cannot be viewed as JSON if it does not exist" do
		max_id = (marketing.db.execute "select id from optins order by id desc limit 1").flatten[0] + 38000
		expect ((JSON.parse(marketing.show_optin(max_id)))["code"]).should eq(404)
	end
end
