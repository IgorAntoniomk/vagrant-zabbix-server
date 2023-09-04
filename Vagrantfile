Vagrant.configure("2") do |config| 
  config.vm.box = "ubuntu/focal64"

  config.vm.provider "virtualbox" do |v|
    v.name = "vagrant-zabbix-server"
  
  end

config.vm.box_download_insecure=true

config.vm.network "forwarded_port", guest: 80, host: 80

config.vm.network "public_network"

  
end
