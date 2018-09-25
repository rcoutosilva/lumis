# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.box = "generic/centos7"
  config.vm.network :private_network, ip: "192.168.100.10"
    config.vm.provider :virtualbox do |vb|
      vb.customize ["modifyvm", :id, "--memory", "4096", "--cpus", "2"]
      config.vm.provision "shell", path: "setup.sh"
    end

end
