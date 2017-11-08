require 'rubygems'
require 'vagrant-node/api'
require 'vagrant-node/pidfile'
require 'webrick'
require 'vagrant-node/dbmanager'
require 'io/console'
require "rbconfig"
#FIXME EVALUAR SI MERECE LA PENA HACER AUTENTICACION DE PASSWORD AQUI
#FIXME Problema con el logging ya que únicamnete
#vuelca al fichero todo cuando se acaba el proceso con el 
#vagrant server stop
module Vagrant
  module Node
		module ServerAPI
			class ServerManager

				
				PIDFILENAME = "server.pid"	
				BIND_ADDRESS = "0.0.0.0"
									
				def self.run(pid_path,data_path,env,port=3333)
					check_password(data_path)
					
					pid_file = File.join(pid_path,PIDFILENAME)

					if File.exists?(pid_file)
						pid = File.read(pid_file).to_i

						begin
  						Process.kill( 'KILL', pid )											
						rescue Errno::ESRCH
													
						end
						PidFile.delete(pid_file)
					end
					

					script = File.join(File.dirname(__FILE__), 'server_sub.rb')
					pid = spawn("ruby " + script + " " + data_path.to_s + " " + port.to_s)
					PidFile.create(pid_file,pid)

					Process.detach pid

				end
			
			

				def self.stop(pid_path,data_path)
					
						
						#check_password(data_path,passwd);
						
						
						pid_file = File.join(pid_path,PIDFILENAME)
						
						if !File.exists?(pid_file)
							return
						end
						
						
						pid = File.read(pid_file).to_i
						
						#Regardless the pid belongs to a running process or not
						#first delete the file
						PidFile.delete(pid_file)
						#FIXME No sé por qué cuando se crea un environment
						#en el cliente, el servidor deja de atrapar la señal 
						#de INT
						#Process.kill('INT', pid)
						Process.kill('KILL', pid)
						#Process.kill 9, pid	
										
					 
										
				end
				
				private

				
				def self.check_password(data_path)				  

					begin
					  	@db = DB::DBManager.new(data_path)					  
					rescue
						if (!@db || !@db.node_password_set? || @db.node_default_password_set?)
							raise "Please, set first a password with the command \"vagrant nodeserver passwd\""				  
						end
					end
				  true
				end

					
			end
		end
  end
end
