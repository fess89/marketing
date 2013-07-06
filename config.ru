# config.ru
$: << File.expand_path(File.dirname(__FILE__))

require './marketing_sinatra'
run Sinatra::Application