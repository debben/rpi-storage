require 'spec_helper'

sdb1_uuid = @default['rpi-storage']['sdb1_uuid']
sdb2_uuid = @default['rpi-storage']['sdb2_uuid']
base_dir = @default['rpi-storage']['base-dir']

describe 'rpi-storage::export' do

  Dir.foreach(node['rpi-storage']['base-dir']) do | item |
    next if item == '.' or item == '..'

    describe file("nfs_mounts/#{item}") do
      it("is a mounted filesystem") do
        expect(subject).to be_directory
        expect(subject).to be_mounted
      end
    end
  end
end