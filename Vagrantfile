Vagrant.configure("2") do |config|
  config.vm.box = "precise64"
  config.vm.box_url = "http://files.vagrantup.com/precise64.box"
  config.vm.network :private_network, ip: "33.33.33.33"

  src_dir = '~/Sites'
  doc_root = '/sites'
  
  config.vm.synced_folder src_dir, doc_root, :create => true, :owner=> 'vagrant', :group=>'www-data', :extra => 'dmode=775,fmode=775'

  config.vm.provision :chef_solo do |chef|
    chef.cookbooks_path = "./cookbooks"
    chef.add_recipe "lamp"
  end
end
