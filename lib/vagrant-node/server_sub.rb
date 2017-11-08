Gem.paths = { 'GEM_HOME' => Dir.home + "/.vagrant.d/gems/2.3.4" }

require 'webrick'
require 'rack'
require_relative 'api'

def server_sub(data_path, port)	
  default_port = 3333
  bind_address = "0.0.0.0"
  log_file = File.open (data_path + "webrick.log").to_s, "a+"

  log = WEBrick::Log.new log_file

  access_log = [[log_file, WEBrick::AccessLog::COMBINED_LOG_FORMAT],]

  port = default_port if port < 1024

  options = {:Port => port, :BindAddress => bind_address,:Logger => log,
             :AccessLog => access_log}

  server = WEBrick::HTTPServer.new(options)

  server.mount "/", Rack::Handler::WEBrick, Vagrant::Node::ServerAPI::API.new

  trap("INT") { server.shutdown }
  
  unless Gem.win_platform?

    trap("USR1") {

      puts "SERVER.RB RESTARTING SERVER"


      server.shutdown


      server = WEBrick::HTTPServer.new(options)
      server.mount "/", Rack::Handler::WEBrick,Vagrant::Node::ServerAPI::API.new
      server.start
    }
  end

        
  server.start

end
server_sub(ARGV[0], ARGV[1].to_i)


