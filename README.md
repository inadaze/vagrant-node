vagrant-node
============

This plugin allows you to set a computer with a virtual environment, configured with Vagrant, to be controlled and managed remotely. The remote machine must have installed the controller plugin, [Vagrant-NodeMaster](https://github.com/fjsanpedro/vagrant-nodemaster/tree/master/lib/vagrant-nodemaster).

With this plugin installed, the Vagrant environment can perform requests, that you usually can execute locally, but commanded by a remote computer. This service is provided through a REST API that this plugin exposes.
	
This plugin has been developed in the context of the [Catedra SAES](http://www.catedrasaes.org) of the University of Murcia(Spain).

##Installation
Requires Vagrant (minimum version 1.2.2) and MySql Server

```bash
$ vagrant plugin install vagrant-node
```

##Configuration 

There is a configuration file located at ~/.vagrant.d/data/config.yml, where you can update the mysql connection settings.

```
---
dbhostname: 127.0.0.1
dbname: mysql
dbuser: root
dbpassword: root
```

##Usage
In order to start the service provided by *vagrant-node* do:

```bash
$ vagrant nodeserver start [port]
```

You run this in the folder which you have performed vagrant init.  The node server will use
the Vagrantfile found within this directory when performing it's remote vagrant commands

Port parameter is optional, its default value is 3333. At the first start, you will be prompted to set a password for that node.

PID file is created in the temp folder of vagrant's data\_dir which defaults to user_home/.vagrant.d/temp/

log file is created in vagrant's data\_dir which defaults to user_home/.vagrant.d/

If you want to stop the service just do the following:

```bash
$ vagrant nodeserver stop
```

If you want to change the node password just execute:

```bash
$ vagrant nodeserver passwd
```


##Errors

### Installing gem mysql2 on ruby 2.4 fails with error message : 

```
 `require': cannot load such file -- mysql2/2.4/mysql2 (LoadError)
```

**Solution**
```
gem install mysql2 --platform ruby -- '--with-mysql-lib="C:\Program Files\MySQL\MySQL Server 5.7\lib" --with-mysql-include="C:\Program Files\MySQL\MySQL Server 5.7\include"'
```

NOTE : make sure to uninstall mysql2-0.4.9-x64-mingw32 if you have two installed


###update required gem mysql2 for vagrant-node in gemspec

spec.add_dependency "mysql2", '~> 0.4.9'



##Debugging Notes:


To see output in a blocking thread, I suggest modifying server.rb method self.run and replace
the contents with : 
```
ServerAPI::API.run! :bind => '0.0.0.0', :port => 3456
```



