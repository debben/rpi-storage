$script = <<SCRIPT

# partition the vdi
(echo n; echo p; echo 1; echo 2048; echo 1049599; echo n; echo p; echo 2; echo 1050624; echo 2097151; echo w;) | fdisk /dev/sdb
# create ext4 filesystems on the partitions.
mkfs -t ext4 /dev/sdb1
mkfs -t ext4 /dev/sdb2

# name and make the UUID's consistent between
# test kitchen create/destroy
e2label /dev/sdb1 "named_disk"
tune2fs /dev/sdb1 -U 76342bc5-b538-4824-bf54-3c3d2540cd1c
tune2fs /dev/sdb2 -U e6475558-2f3d-4d1f-830b-f9ce50ad211f
SCRIPT

VAGRANTFILE_API_VERSION = "2"
Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.provider "virtualbox" do |vb|
    vb.customize ["createhd", "--filename", "disk2.vdi", "--size", 1024]
    vb.customize ["storageattach", :id, "--storagectl", "SATA Controller", "--medium", "disk2.vdi", "--port", 1, "--device", 0,"--type", "hdd"]
  end
  config.vm.provision :shell, :inline => $script
end
