require "sqlite3"

class Marketing::SqliteConnector < SQLite3::Database

	#get the interface
	def initialize(db_name = "optins.db")
		super(db_name)
	end

	#TODO: load SQL schema from file
	def create_db(db_name = "optins.db")
		self.execute <<-SQL
  			create table optins (
  				`id` INTEGER PRIMARY KEY NOT NULL,
    			`email` varchar(255),
    			`mobile` varchar(20),
    			`first_name` varchar(255),
    			`last_name` varchar(255),
    			`permission_type` varchar(255),
    			`channel` varchar(255),
    			`company_name` varchar(255)
  			);
		SQL
	end
end