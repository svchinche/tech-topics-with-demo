Learning Ansible 
================


Table of contents
=================

<!--ts-->
   * [Installing Ansible](#installing-ansible)
   * [Inventory](#inventory)
   * [Modules](#modules)
      * [Shell module](#shell-module)
   * [Roles](#roles)
      * [Creating a roles](#creating-a-roles)
      * [Run roles](#run-roles)
   * [Kubernetes python client](#kubernetes-python-client)
   * [Multistage environment variables](#multistage-environment-variables)
   * [Vaults](#vaults)
   * [Python and Pip installation](#python-and-pip-installation)
   * [Understanding Relative directories using builtin ansible variables](#understanding-relative-directories-using-builtin-ansible-variables)
   * [Best Practices for using roles](#best-practices-for-roles)
<!--te-->


Adding Bridge Network in Vagrant to access from outside network.
=========================
Add below line on Vagrant file
173: master.vm.network "public_network", bridge: "Cisco AnyConnect Secure Mobility Client Virtual Miniport Adapter for Windows x64"


master.vm.network "public_network", bridge: "Cisco AnyConnect Secure Mobility Client Virtual Miniport Adapter for Windows x64"
```
$ vagrant.exe up master
HTTP proxy: http://www-proxy-hqdc.us.oracle.com:80/
HTTPS proxy: http://www-proxy-hqdc.us.oracle.com:80/
No proxy: localhost,127.0.0.1,192.168.99.100,192.168.99.101,192.168.99.102
Bringing machine 'master' up with 'virtualbox' provider...
==> master: Clearing any previously set forwarded ports...
==> master: Clearing any previously set network interfaces...
==> master: Preparing network interfaces based on configuration...
    master: Adapter 1: nat
    master: Adapter 2: bridged
    master: Adapter 3: hostonly
```

Vagrant::Config.run do |config|
  config.vm.network :bridged
end

Vagrant::Config.run do |config|   
  config.vm.network :bridged 
end

1) Intel(R) Dual Band Wireless-AC 8265
2) Cisco AnyConnect Secure Mobility Client Virtual Miniport Adapter for Windows x64

Adapter 2: bridged


[
  "en2: Wi-Fi (AirPort)",
  "en6: Broadcom NetXtreme Gigabit Ethernet Controller",
]



Vagrant::Config.run do |config|   
  config.vm.network "public_network", bridge: "Cisco AnyConnect Secure Mobility Client Virtual Miniport Adapter for Windows x64"
end


Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  if Vagrant.has_plugin?("vagrant-proxyconf")
    config.proxy.http     = "http:///www-proxy.us.oracle.com:80/"
    config.proxy.https    = "https:///www-proxy.us.oracle.com:80/"
    config.proxy.no_proxy = "localhost,127.0.0.1,.vagrant.vm"
  end
end


Environment="HTTP_PROXY=https:///www-proxy.us.oracle.com:80/"
Environment="HTTPS_PROXY=https:///www-proxy.us.oracle.com:80/"


Environment="HTTP_PROXY=http://www-proxy-hqdc.us.oracle.com:80/"
Environment="HTTPS_PROXY=http://www-proxy-hqdc.us.oracle.com:80/"

systemctl daemon-reload; systemctl stop docker ; systemctl start docker

export HTTP_PROXY=http://www-proxy-hqdc.us.oracle.com:80/"
export HTTPS_PROXY=http://www-proxy-hqdc.us.oracle.com:80/"
