require 'spec_helper'

sdb1_uuid = @default['rpi-storage']['sdb1_uuid']
sdb2_uuid = @default['rpi-storage']['sdb2_uuid']

describe 'rpi-storage::default' do
  # Serverspec examples can be found at
  # http://serverspec.org/resource_types.html
  
    describe file("/media/removable")  do
       it 'is a directory' do
         expect(subject).to be_directory 
       end
    end

    describe file("/media/removable/#{sdb2_uuid}") do
       it 'is a directory' do
         expect(subject).to be_directory
       end

       it 'is mounted to a block device' do       	
         expect(subject).to be_mounted
       end
    end

    describe file("/media/removable/named_disk") do
      it 'is a directory' do
        expect(subject).to be_directory
      end

      it 'is mounted to a block device' do
        expect(subject).to be_mounted
      end       
    end

    describe file("/etc/fstab") do
      it 'contains entries for sdb' do
        expect(subject).to contain Regexp.new("UUID=#{sdb2_uuid} /media/removable/#{sdb2_uuid}")
        expect(subject).to contain Regexp.new("UUID=#{sdb1_uuid} /media/removable/named_disk")
      end
    end
  
end
