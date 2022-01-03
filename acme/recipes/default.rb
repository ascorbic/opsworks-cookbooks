# https://github.com/schubergphilis/chef-acme/blob/78591b0988472fbde989e2b93a3036b67059b748/recipes/default.rb
chef_gem 'acme-client' do
    action :install
    version '0.3.0'
    compile_time true if respond_to?(:compile_time)
end

require 'acme-client'