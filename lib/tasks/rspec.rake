desc "Hacked up job to run specs"

task :spec do
  sh "rspec spec"
end

task :default => [:spec]
