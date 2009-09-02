module Arabesque

 class QueuesManager
    
   def initialize(data_folder,queues_per_file=100)  
       @queues_per_file = 100
       @data_folder = data_folder
       @bdb_env = BDB::Env.new(data_folder)
       @queues = {}
       @queues_hash =  @bdb_env.hash("queues", "name")
   end

   def add_queue(name,file="queues",marshal=false)
        #@current_file_number+= 1 if @queues.length % @queues_per_file == 0
        @queues_hash.get(name) ? nil : @queues_hash.put(name,1);@queues[name]  = @bdb_env.btree(file, name,marshal)
   end 

   def push_to_queue(name,data)
        current_queue = @queues[name] ? @queues[name] : (@queues_hash.get(name) ? @bdb_env.btree("queues", name) : nil )
        current_queue ? current_queue.put(Time.now.to_f,data) : nil
   end  

   def pull_messages_from_queue(name,time)
        current_queue = @queues[name] ? @queues[name] : (@queues_hash.get(name) ? @bdb_env.btree("queues", name) : nil )
        current_queue ? current_queue.get_bigger(time) : nil  
   end

  def pop_from_queue(name)
        current_queue = @queues[name] ? @queues[name] : (@queues_hash.get(name) ? @bdb_env.btree("queues", name) : nil )
        current_queue ? current_queue.pop[1] : nil  
  end
 
  def delete_less_than(name, time)
     current_queue = @queues[name] ? @queues[name] : (@queues_hash.get(name) ? @bdb_env.btree("queues", name) : nil )
     current_queue ? current_queue.delete_less_than(time) : nil  
  end

    def close_queue(name)
     current_queue = @queues[name] ? @queues[name] : (@queues_hash.get(name) ? @bdb_env.btree("queues", name) : nil )
     current_queue ? current_queue.close : nil  
  end

  def close_env
     @bdb_env.close
  end 

 end

end
