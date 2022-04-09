Vagrant.configure("2") do |config|
  config.vm.box = "ubuntu/focal64"

  config.vm.define :web do |web|
    web.vm.network "private_network", ip: "192.168.56.10"
    web.vm.provision "shell", path: "scripts/puppet_install.sh"
  end
end