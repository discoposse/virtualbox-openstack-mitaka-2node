# -*- mode: ruby -*-
# vi: set ft=ruby :

# If container_sync
# enable swift2
# configure swift and swift2 with container_sync configs (execute extra script at end)

# If dvr
# add second compute:   'compute' => [2,202]
# configure compute-01 and compute-01 for dvr

# Uncomment the next line to force use of VirtualBox provider when Fusion provider is present
# ENV['VAGRANT_DEFAULT_PROVIDER'] = 'virtualbox'
# Or specify --provide=virtualbox on command line

nodes = {
    'controller'  => [1, 200],
    'compute'  => [1, 202],
}

Vagrant.configure("2") do |config|
    
  # Defaults
  config.vm.box = "trusty-x64"
  config.vm.synced_folder ".", "/vagrant", type: "nfs"

  # VirtualBox
  config.vm.provider :virtualbox do |vbox, override|
    override.vm.box = "bunchc/trusty-x64"
    if Vagrant::Util::Platform.windows? 
      override.vm.synced_folder ".", "/vagrant", mount_options: ["dmode=700","fmode=700"]
    else
      override.vm.synced_folder ".", "/vagrant", type: "nfs"
    end
  end

  #Default is 2200..something, but port 2200 is used by forescout NAC agent.
  config.vm.usable_port_range= 2800..2900 

  unless Vagrant::Util::Platform.windows? 
    if Vagrant.has_plugin?("vagrant-cachier")
      config.cache.scope = :box
      config.cache.enable :apt
      config.cache.synced_folder_opts = {
        type: :nfs,
        mount_options: ['rw', 'vers=3', 'tcp', 'nolock']
      }
    else
      puts "[-] WARN: This would be much faster if you ran vagrant plugin install vagrant-cachier first"
    end
  end

  nodes.each do |prefix, (count, ip_start)|
    count.times do |i|
    hostname = "%s" % [prefix, (i+1)]

      config.vm.define "#{hostname}" do |box|
        box.vm.hostname = "#{hostname}.cook.book"
        box.vm.network :private_network, ip: "10.0.0.#{ip_start+i}", :netmask => "255.255.255.0"
        box.vm.network :private_network, type: "dhcp" 

        box.vm.provision :shell, :path => "#{prefix}.sh"

        box.vm.provider :virtualbox do |vbox|

          # Things will fail if running Windows + VirtualBox without vbguest
          if Vagrant::Util::Platform.windows?
            unless Vagrant.has_plugin?("vagrant-vbguest") 
              raise 'Please install vagrant-vbguest. Running this environment under Windows will fail otherwise. Install with: vagrant plugin install vagrant-vbguest'
            end 
          end

          # Defaults
          vbox.customize ["modifyvm", :id, "--memory", 3072]
          vbox.customize ["modifyvm", :id, "--cpus", 2]
          vbox.customize ["modifyvm", :id, "--nicpromisc1", "allow-all"]
          vbox.customize ["modifyvm", :id, "--nicpromisc2", "allow-all"]
        end
      end
    end
  end
end