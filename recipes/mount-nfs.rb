#
# Cookbook Name:: rpi-storage
# Recipe:: mount-nfs
#
# Copyright (c) 2015 Don Ebben, All Rights Reserved.
# 
# This recipie is just for running tests. It's intended to mount the shares
# on the server to another location on the server.

include_recipe "nfs::default"

directory node['rpi-storage']['imports-dir'] do
  owner 'root'
  group 'root'
  mode '0755'
  action :create
end

node['rpi-storage']['shares'] .each do | item |
  directory "#{node['rpi-storage']['imports-dir']}/#{item}" do
    owner 'root'
    group 'root'
    mode '0755'
    action :create
  end

  # for testing only.
  mountActions = node['rpi-storage']['removable'] == '0' ? :nothing : [:mount, :enable]
  
  mount "#{node['rpi-storage']['imports-dir']}/#{item}"do    
    device "#{node['rpi-storage']['exports-host']}:/#{node['rpi-storage']['exports-dir']}/#{item}"  
    fstype "nfs"
    action  mountActions
    not_if mounted
    subscribes :mount, "nfs_export[#{item}]", :delayed
    subscribes :enable, "nfs_export[#{item}]", :delayed
  end
end