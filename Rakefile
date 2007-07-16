require 'rake'
require 'rake/testtask'
require 'rake/rdoctask'
require 'test/rails_root/vendor/plugins/00_rspec/lib/spec/rake/spectask'

desc 'Default: run unit tests.'
task :default => :test

desc 'Test the has_ancestor plugin.'
Rake::TestTask.new(:test) do |t|
  t.libs << 'lib'
  t.pattern = 'test/unit/**/*_test.rb'
  t.verbose = true
end

desc "Run has_ancestor plugin specs"
Spec::Rake::SpecTask.new(:spec) do |t|
  t.spec_files = FileList['test/spec/specs/**/*_spec.rb']
  t.spec_opts = ['--options', 'test/spec/spec.opts']
end

desc "Generate HTML report for has_ancestor examples"
Spec::Rake::SpecTask.new(:spec_report) do |t|
  t.spec_files = FileList['test/spec/specs/**/*_spec.rb']
  t.spec_opts = ["--format", "html:/var/www/dev/rspec/has_ancestor.html", "--diff"]
  t.fail_on_error = false
end

desc 'Generate documentation for the has_ancestor plugin.'
Rake::RDocTask.new(:rdoc) do |rdoc|
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title    = 'HasAncestor'
  rdoc.options << '--line-numbers' << '--inline-source'
  rdoc.rdoc_files.include('README')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
