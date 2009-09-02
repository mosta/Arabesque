# stable libraries
require 'environment'
require 'sinatra'
# application libraries
include Arabesque
##############################
configure do
end


# Create A Queue
post '/queues' do
  puts params[:name]
  room = @@queues_manager.add_queue(params[:name])
  room ? "Queue #{params[:name]} has  been created" : "Error"
end


get '/queues/:id/' do
  response = @@queues_manager.pop_from_queue(params[:id])  
  response ? response  : 'Error'
end

# Post message
post '/queues/:id/' do
  response = @@queues_manager.push_to_queue(params[:id],params[:message]) #Send Messages
  response ? "Created" : 'Error'
end
