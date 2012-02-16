require 'rake/testtask'

`gem build nugen_barcode_splitter.gemspec`
`gem install nugen_barcode_splitter-0.0.1.gem`

Rake::TestTask.new do |t|
  t.libs << 'test'
  t.test_files = FileList['test/test*.rb']
  t.verbose = true
end

desc "Run tests"
task :default => :test
