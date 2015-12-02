require 'serverspec'

if (/cygwin|mswin|mingw|bccwin|wince|emx/ =~ RUBY_PLATFORM).nil?
  set :backend, :exec
else
  set :backend, :cmd
  set :os, family: 'windows'
end

# taken from this issue https://github.com/test-kitchen/busser-serverspec/issues/8
class MyHash < Hash
  alias_method :orig_subscript, :'[]'
  define_method(:'[]') do |subscript|
    send(:'[]=', subscript, MyHash.new) unless orig_subscript(subscript)
    orig_subscript(subscript)
  end
end

default = node = override = MyHash.new

eval IO.read('/tmp/kitchen/cookbooks/rpi-storage/attributes/default.rb')

@default = default
