Gem::Specification.new do |s|
  	s.name         = 'marketing'
  	s.version      = '0.0.1'
  	s.date         = '2013-07-02'
  	s.summary      = "Working with marketing opt-ins"
    s.description  = "Test task given by Alexander Simonov"
  	s.authors      = ["Oleksii Chyrkov"]
  	s.email        = 'chyrkov@kth.se'
		s.files        = Dir['lib/**/*.rb']
  	s.require_path = 'lib'
  	s.license      = "MIT"
  	s.platform     = Gem::Platform::RUBY

  	#sqlite3 is required
  	s.add_runtime_dependency "sqlite3", "~> 1.3.3" 
    s.add_runtime_dependency "json", "~> 1.8.0"

    #rspec is only for testing
    s.add_development_dependency "rspec", "~> 2.14.0.rc1" 
end
