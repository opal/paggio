#! /usr/bin/env ruby
require 'rake'

task :default => [:install, :test]

task :install do
	sh 'gem install --no-force rspec'
	sh 'gem build *.gemspec'
	sh 'gem install *.gem'
end

task :test do
	FileUtils.cd 'spec' do
		sh 'rspec css_spec.rb html_spec.rb --backtrace --color --format doc'
	end
end
