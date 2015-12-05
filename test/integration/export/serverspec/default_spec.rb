require 'spec_helper'

base_dir = @default['rpi-storage']['base-dir']
imports_dir = '/media/nfs_mounts'
exports_dir  = '/media/removable'
local_imports_dir = '/media/local_imports'

describe 'rpi-storage::export' do
    ['nfs-kernel-server', 'nfs-common'].each do | nfs |  
      describe service(nfs) do
        it 'should be enabled and running' do        
          expect(subject).to be_running
        end
      end
     end    

  Dir.foreach(exports_dir) do | item |
    next if item == '.' or item == '..'

    # Test the storage-provider local share
    describe file("#{local_imports_dir}/#{item}") do
      it("is a symlink to #{exports_dir}/#{item}") do
        expect(subject).to be_symlink
        expect(subject).to be_linked_to "#{exports_dir}/#{item}"
      end
    end
  end
end