marketing
=========

Marketing Opt-ins service. Solution of a test task given by Alexander Simonov.

Installation
------------

    mkdir marketing  
    cd marketing
    git clone https://github.com/fess89/marketing .
    git checkout sinatra
    bundle install
    sudo apt-get install sqlite3
    rake db_create
    rake db_seed

Running
-------

    rackup -p 4567 -D
    
or

    ruby marketing_sinatra.rb

Testing
-------
    rake

