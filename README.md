marketing
=========

Marketing Opt-ins service. Solution of a test task given by Alexander Simonov.

Running
-------

    rackup -p 4567 -D
    
or

    ruby marketing_sinatra.rb

Testing
-------
    mkdir marketing  
    cd marketing
    git clone https://github.com/fess89/marketing .
    bundle install
    sudo apt-get install sqlite3
    rake db_create
    rake db_seed
    rake

