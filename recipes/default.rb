#
# Cookbook Name:: rpi-storage
# Recipe:: default
#
# Copyright (c) 2015  Don Ebben

# make sure all non-standard block devices are mounted
# and exist under fstab

directory node['rpi-storage'] ['base-dir'] do
      owner 'root'
      group 'root'
      mode '0755'
      action :create
end

devices = node['block_device'].select do |name,details|
  details['removable'] == node['rpi-storage']['removable']
end

devices.each do |device_name,details|
  # we now have the removable storage devices. Let's make sure for
  # all of their partitions, we have mountpoints setup.

  partitions = node['filesystem'].select do |partition_name, details|
    partition_name =~ /^\/dev\/#{device_name}/
  end

  partitions.each do |partition_name, details|
    path_name = ""

    # for the purposes of testing, ignore anything already mounted to "/"
    if details['mount'] != nil and details['mount'] == '/' or details['fs_type'] == 'swap'
      next
    end

    # use UUID if the partition has no label
    if details['label'] == nil
      path_name = details["uuid"]
    else
      path_name = details['label']
    end

    directory "#{node['rpi-storage'] ['base-dir']}/#{path_name}" do
      owner 'root'
      group 'root'
      mode '0755'
      action :create
    end

    mount "#{node['rpi-storage'] ['base-dir']}/#{path_name}" do
      device details['uuid']
      device_type :uuid # use uuid to prevent /dev/sd* mixups
      fstype details["fs_type"]
      action [:mount, :enable] # mount and keep mounting on subsequent boots
    end
  end
end