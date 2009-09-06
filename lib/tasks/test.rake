namespace :test do
  Rake::TestTask.new(:implementation) do |t|
    t.libs << 'test'
    t.test_files = FileList["#{RAILS_ROOT}/test/implementation/*.rb"]
    t.verbose = true
  end
end
