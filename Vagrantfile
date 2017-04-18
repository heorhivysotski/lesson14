# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.define "server" do |puppet|
	puppet.vm.hostname = "server.hv"
	puppet.vm.box = "centos7"
	puppet.vm.network "private_network", ip: "192.168.20.100"
	puppet.vm.provider "virtualbox" do |vb|
	  vb.cpus = 2
	  vb.memory = 4096
	end
	
	master.vm.provision "shell", inline: <<-SHELL
	sudo rpm -Uvh https://yum.puppetlabs.com/puppetlabs-release-pc1-el-7.noarch.rpm
	sudo yum install -y puppetserver
        echo "192.168.20.10 agent.hv" >> /etc/hosts
	sudo systemctl restart network
 	sudo cp /vagrant/autosign.conf /etc/puppetlabs/puppet 	
	sudo systemctl start puppetserver
	source ~/.bashrc
        sudo cp -R /vagrant/modules/* /etc/puppetlabs/code/environments/production/modules
        sudo chmod -R 0777 /etc/puppetlabs/code/environments/production/modules/jboss/files
        sudo cp /vagrant/site.pp /etc/puppetlabs/code/environments/production/manifests
	SHELL
  end

  config.vm.define "agent" do |puppet|
	puppet.vm.hostname = "agent.hv"
	puppet.vm.box = "centos7"
	puppet.vm.network "private_network", ip: "192.168.20.10"
	puppet.vm.provider "virtualbox" do |vb|
	  vb.cpus = 1
	  vb.memory = 1024
	end
	
	node.vm.provision "shell", inline: <<-SHELL
	sudo rpm -Uvh https://yum.puppetlabs.com/puppetlabs-release-pc1-el-7.noarch.rpm
	yum install -y puppet-agent
        echo "192.168.20.100 server.hv" >> /etc/hosts
	sudo systemctl restart network
	echo "server = server.hv" >> /etc/puppetlabs/puppet/puppet.conf	
	sudo /opt/puppetlabs/bin/puppet resource service puppet ensure=running enable=true
	SHELL
  end 
end 
