require "sqlite3"

class Marketing::SqliteConnector < SQLite3::Database

	# Opens a database 
  # Params:
  # +db_name:: optional name of database file (will be created if it does not exist)
	def initialize(db_name = "optins.db")
		super(db_name)
	end

	# Creates a database suitable for storing optins
  # Params:
  # +db_name:: optional name of database file (will be created if it does not exist)
  # TODO: load DB schema from file
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