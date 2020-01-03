# -*- mode: ruby -*-
# vi: set ft=ruby :

STORAGE_DISK_SIZE_GB = 10 * 1024

Vagrant.configure("2") do |config|
  config.vm.box = "generic/debian10"

  config.vm.provision "ansible" do |ansible|
    ansible.compatibility_mode = "2.0"
    ansible.playbook = "site.yml"
    ansible.verbose = "vv"
    ansible.groups = {
      "storage" => ["stor1", "stor2", "stor3"],
      "k8s" => ["kube"],
    }
  end

  (1..3).each do |mach_id|
    config.vm.define "stor#{mach_id}" do |it|
      it.vm.hostname = "stor#{mach_id}"
      it.vm.network :private_network, ip: "192.168.202.#{200+mach_id}"
      it.vm.provider "virtualbox" do |vb|
        # Create another disk as IDE HDD.
        storage_disk = File.join(Dir.pwd, "stor#{mach_id}-storage.vdi")
        unless File.exist?(storage_disk)
          vb.customize ["createhd", "--filename", storage_disk,
                        "--format", "VDI", "--size", STORAGE_DISK_SIZE_GB]
        end
        vb.customize ['storageattach', :id, '--storagectl',
                      'IDE Controller', '--port', 0, '--device',
                      1, '--type', 'hdd', '--medium', storage_disk]
      end
    end
  end

  config.vm.define "kube" do |kube|
    kube.vm.hostname = "kube"
    kube.vm.network :private_network, ip: "192.168.202.245"
  end
end
