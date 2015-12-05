#
# Cookbook Name:: rpi-storage
# Recipe:: export
#
# Copyright (c) 2015 Don Ebben, All Rights Reserved.
# 
# Creates an NFS share for each name in the ["share"] attribute

include_recipe "nfs::server"

# give the ability to override the attribute
node.default['rpi-storage']['exports-dir'] = node['rpi-storage']['base-dir']

# use a local imports dir to give the ability to override using imports-
# dir on the storage provider
importsDir = node['rpi-storage']['local-imports-dir'] != nil ? node['rpi-storage']['local-imports-dir'] : node['rpi-storage']['imports-dir']

# create impots directory if it doesn't already exist
directory importsDir do
  owner 'root'
  group 'root'
  mode '0755'
  action :create
end

node['rpi-storage']['shares'] .each do | item |
  nfs_export item do |variable|
    directory "#{node['rpi-storage']['exports-dir']}/#{item}" 
    network '*' # wildcard for now.
    writeable true 
    options ['no_root_squash']
    action :create
  end

  # make a local import to the symlink, so on the machine providing the share,
  # applications expecting /importPath/shareName can still use that path if the
  # application happens to be running on the storage provider.
  link "#{importsDir}/#{item}" do |variable|
    to "#{node['rpi-storage']['exports-dir']}/#{item}"
    link_type :symbolic
    action :create
  end
end