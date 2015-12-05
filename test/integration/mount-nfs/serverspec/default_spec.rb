require 'spec_helper'

base_dir = @default['rpi-storage']['base-dir']
imports_dir = '/media/nfs_mounts'
exports_dir  = '/media/removable'
local_imports_dir = '/media/local_imports'

describe 'rpi-storage::nfs-mount' do
  describe service('nfs-common') do
    it 'should be enabled and running' do        
      expect(subject).to be_running
    end
  end

  Dir.foreach(exports_dir) do | item |
    next if item == '.' or item == '..'

    # Test the mount
    describe file("#{imports_dir}/#{item}") do
          it("is a mounted filesystem") do
            expect(subject).to be_directory
            expect(subject).to be_mounted
          end
    end
  end
end