packages = %w{git apache2 curl mysql-server php5 libapache2-mod-php5 php5-mysql php5-curl php5-cli php5-common php-pear php5-dev php5-gd}

execute "apt-get update" do
  command "apt-get update"
end

packages.each do |pkg|
  package pkg do
  	action :install
#   action [:install, :upgrade]
#   version node.default[:versions][pkg]
  end
end


### phpunit
execute "phpunit-install" do
  command "pear config-set auto_discover 1; pear install pear.phpunit.de/PHPUnit"
  not_if { ::File.exists?("/usr/bin/phpunit")}
end

### composer
execute "composer-install" do
  command "curl -sS https://getcomposer.org/installer | php ;mv composer.phar /usr/local/bin/composer"
  not_if { ::File.exists?("/usr/local/bin/composer")}
end


### apache2
bash "rewrite" do
  code <<-EOC
    sudo a2enmod rewrite
  EOC
end

template "/etc/apache2/sites-available/default" do
  source "apache2.conf.erb"
  owner "root"
  group "root"
  mode 0644
end

service "apache2" do
  supports :status => true, :restart => true, :reload => true
  action [:enable, :start]
end


### mysql
service "mysql" do
  action [ :enable, :start]
end

### group
group "www-data" do
  action :modify
  members ['vagrant']
  append true
end
