class Marketing::Optin
	@@CHANNEL_TYPES = ['sms', 'email', 'sms+email']
	@@PERMISSION_TYPES = ['one-time', 'permanent']

	#attr_accessor is redefined for the class to know all its attributes
	def self.attr_accessor(*vars)
	   @attributes ||= []
	   @attributes.concat vars
	   super(*vars)
	end

	#getting everything which is attr_accessor
	def self.attributes
	    @attributes
  	end

	attr_accessor :id, :email, :mobile, :first_name, :last_name, :permission_type, :channel, :company_name

	def initialize(params)
		self.class.attributes.each do |key|
			instance_variable_set("@#{key.to_sym}", params[key])
		end
	end

	#primitive validation, Active Record would do better
	def valid?
		res = true
		#TODO: validate email
		res = (!@email.empty?) && res
		res = (!@mobile.empty?) && res
		res = (!@first_name.empty?) && res
		res = (!@last_name.empty?) && res
		res = (!@company_name.empty?) && res
		res = @@PERMISSION_TYPES.include?(@permission_type) && res
		res = @@CHANNEL_TYPES.include?(@channel) && res
	end

	#saving optin to db
	def save(db)
		if self.valid?
			db.execute2 "insert into optins values(null, '#{email}', '#{mobile}', '#{first_name}',
													'#{last_name}', '#{permission_type}', 
													'#{channel}', '#{company_name}');"
			return db.changes > 0 ? true : nil
		else
			return nil
		end
	end

	#deleting optin
	def deactivate(db)
		db.execute "delete from optins where id=#{self.id}"
		return db.changes > 0 ? true : nil
	end

	#updating optin with new data
	def update(db, params)
		set = ""
		params.each do |key, value|
			if (self.class.attributes.include?(key.to_sym) && (key != :id))
				set += "#{key}='#{value}', "
			end
		end
		set = set[0..-3]
		db.execute2 "update optins set #{set} where id=#{id}; "
		return db.changes > 0 ? true : nil
	end

	#returns number of rows where column "key" is equal to "value"
	def self.find_by_params(db, params)
		where = ""
		params.each do |key, value|
			if @attributes.include?(key.to_sym)
				where += "#{key}=\"#{value}\" and "
			end
		end
		where = where[0..-6]
		#TODO: escape sql symbols
		res = db.execute "select * from optins where #{where} order by id desc limit 1"
		if res.empty?
			return nil
		else
			params = Hash.new
			res = res.flatten
			attributes.each do |key|
				params[key] = res.shift
			end
			return self.new(params)
		end
	end

	#converts optin to JSON hash
	def to_json
		json_hash = Hash.new
		self.class.attributes.each do |key|
			json_hash[key] = instance_variable_get("@#{key}")
		end
		return json_hash.to_json
	end
end