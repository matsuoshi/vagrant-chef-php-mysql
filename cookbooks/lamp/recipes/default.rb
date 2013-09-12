packages = %w{apache2 git curl mysql-server libapache2-mod-php5}
packages_php =%w{php5 php5-mysql php5-curl php5-cli php5-common php-pear php5-dev php5-gd}
php_version = "5.4*"


### for php5.4
execute "1st apt-get update" do
  command "apt-get update"
end

package "python-software-properties" do
  action [:install, :upgrade]
end  

execute "add ppa:ondrej/php5-oldstable" do
  command "add-apt-repository ppa:ondrej/php5-oldstable"
#  command "add-apt-repository ppa:ondrej/php5"
end


### install
execute "apt-get update" do
  command "apt-get update"
end


### install packages
packages.each do |pkg|
  package pkg do
    action :install
  end
end

### install php
packages_php.each do |pkg|
  package pkg do
    action [:install, :upgrade]
	version php_version
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
