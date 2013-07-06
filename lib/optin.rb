class Marketing::Optin

	# Redefines attr_accessor for the class
	# so that an object would know all its attr_accessor attributes
	def self.attr_accessor(*vars)
	   @attributes ||= []
	   @attributes.concat vars
	   super(*vars)
	end

	# Returns an array of attribute names for attributes defined as attr_accessor
	def self.attributes
	    @attributes
  	end

  	# Returns an array of valid channel types (could use @@channel_types instead)
  	def self.channel_types
    	['sms', 'email', 'sms+email']
  	end

	# Returns an array of valid permission types (could use @@permission_types instead)
  	def self.permission_types
    	['one-time', 'permanent']
  	end

	attr_accessor :id, :email, :mobile, :first_name, :last_name, :permission_type, :channel, :company_name

	# Creates a new Optin
	# Params:
	# +params:: hash which has attribute names as keys and their intended values as values
	def initialize(params)
		hash = Hash[params.map{|(k,v)| [k.to_sym,v]}]
		self.class.attributes.each do |key|
			instance_variable_set("@#{key.to_sym}", hash[key])
		end
	end

	# Checks that an optin is valid (could be saved to database)
	# Intended to be executed before save, just like in ActiveRecord
	def valid?
		if @email.nil? || @mobile.nil? || @first_name.nil? || @last_name.nil? || @company_name.nil? || @permission_type.nil? || @channel.nil?
			return false
		end
		if @email.empty? || @mobile.empty? || @first_name.empty? || @last_name.empty? || @company_name.empty? || @permission_type.empty? || @channel.empty?
			return false
		end
		if !self.class.permission_types.include?(@permission_type) 
			return false
		end
		if !self.class.channel_types.include?(@channel) 
			return false
		end
		return true
	end

	# Saves an optin to database if it is valid
	# Params:
	# +db:: an SQLite3::Database object which is assumed to be open
	# TODO: put the SQLite code into the SqliteConnector object and make it a bit more dynamic 
	# At the very least, the method checks is db is really an SQLite3::Database object
	def save(db)
		if (self.valid? && db.is_a?(SQLite3::Database))
			db.execute2 "insert into optins values(null, '#{email}', '#{mobile}', '#{first_name}',
													'#{last_name}', '#{permission_type}', 
													'#{channel}', '#{company_name}');"
			return db.changes > 0 ? true : nil
		else
			return nil
		end
	end

	# Deletes an optin from database
	# Params:
	# +db:: an SQLite3::Database object which is assumed to be open
	# At the very least, the method checks is db is really an SQLite3::Database object
	# Returns the number of rows changed in the DB or nil if nothing was changed or the DB is invalid
	def deactivate(db)
		if db.is_a?(SQLite3::Database)
			db.execute "delete from optins where id=#{self.id}"
			return db.changes > 0 ? true : nil
		else
			return nil
		end
	end

	# Updates an optin with new data
	# Params:
	# +db:: an SQLite3::Database object which is assumed to be open
	# +params:: a hash which may hold all of some of the optin attributes and other key-value pairs
	# Example: { :first_name => "Bill", :last_name => "Gates", :company_name => "Microsoft" }
	# At the very least, the method checks is db is really an SQLite3::Database object
	# and that the hash is not empty
	# Returns the number of rows changed in the DB or nil if nothing was changed or the DB is invalid
	def update(db, params)
		if params.empty?
			return nil
		end
		if db.is_a?(SQLite3::Database)
			set = ""
			params.each do |key, value|
				if (self.class.attributes.include?(key.to_sym) && (key != :id))
					set += "#{key}='#{value}', "
				end
			end
			set = set[0..-3]
			db.execute2 "update optins set #{set} where id=#{id}; "
			return db.changes > 0 ? true : nil
		else
			return nil
		end
	end

	# Tries to find an Optin in a database according to parameters
	# Params:
	# +db:: an SQLite3::Database object which is assumed to be open
	# +params:: a hash which may hold all of some of the optin attributes and other key-value pairs
	# At the very least, the method checks is db is really an SQLite3::Database object
	# and that the hash is not empty
	# Returns the most recent Optin found (in case more than one fits), 
	# nil if nothing is found, nil if DB is invalid, nil if params are empty
	# TODO: escape sql symbols
	def self.find_by_params(db, params)
		if params.empty?
			return nil
		end
		where = ""
		params.each do |key, value|
			if @attributes.include?(key.to_sym)
				where += "#{key}=\"#{value}\" and "
			end
		end
		where = where[0..-6]
		res = db.execute "select * from optins where #{where} order by id desc limit 1"
		if res.empty?
			return nil
		end
		params = Hash.new
		res = res.flatten
		attributes.each do |key|
			params[key] = res.shift
		end
		return self.new(params)
	end

	# Converts optin to JSON
	# Returns a JSON string
	def to_json
		json_hash = Hash.new
		self.class.attributes.each do |key|
			json_hash[key] = instance_variable_get("@#{key}")
		end
		return json_hash.to_json
	end
end