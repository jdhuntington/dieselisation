DEPS_DIR = File.expand_path(File.join(File.dirname(__FILE__), '..', '..', 'deps'))
LIB_DIR = File.join(DEPS_DIR, 'lib')
INCLUDE_DIR = File.join(DEPS_DIR, 'include')
SRC_DIR = File.join(DEPS_DIR, 'src')
BIN_DIR = File.join(DEPS_DIR, 'bin')
GEM_DIR = File.join(DEPS_DIR, 'lib', 'ruby', 'gems', '1.8', 'gems')

desc 'Setup to run before working on project'
task :setup => :build do
  exec "CURRENT_PROJECT='dieselisation' ADDPATH='#{BIN_DIR}' #{ENV['SHELL']}"
end

desc 'Build software dev environment dependencies'
task :build => [DEPS_DIR, SRC_DIR, 'build:ruby', 'build:gems']

file DEPS_DIR do
  sh "mkdir -pv '#{DEPS_DIR}'"
end

file SRC_DIR => DEPS_DIR do
  sh "mkdir -pv '#{SRC_DIR}'"
end

namespace :build do
  task :ruby => [:readline, File.join(BIN_DIR, 'ruby')]

  task :readline => File.join(INCLUDE_DIR, 'readline', 'readline.h')

  def add_gem(name, version)
    task_name = name.gsub(/\W/, '_')
    dir_name = File.join(GEM_DIR, "#{name}-#{version}")
    task :gems => ["gems:#{task_name}"]
    namespace :gems do
      task task_name.to_sym => ['gems:gem',dir_name]
      file dir_name do
        sh "#{BIN_DIR}/gem install #{name} -v #{version}"
      end
    end
  end

  def add_gems(&blk)
    gems = blk.call
    gems.each_slice(2) do |name, version|
      add_gem name, version
    end
  end

  add_gems do
    %w(
      rake 0.8.3
      mongrel 1.1.5
      rspec-rails 1.1.12
      selenium-client 1.2.10
      rack 0.9.1
      capistrano 2.5.5
      capistrano-ext 1.2.1
      unit_record 0.9.0
      mocha 0.9.5
    )
  end
  
  file File.join(BIN_DIR, 'ruby') => File.join(SRC_DIR, 'ruby-1.8.7-p72') do
    sh "cd #{File.join(SRC_DIR, 'ruby-1.8.7-p72')} && " +
      "./configure --enable-install-doc --prefix=#{DEPS_DIR} --with-readline-dir=#{DEPS_DIR} && " +
      "make -j 3 && make install"
  end

  file File.join(SRC_DIR, 'ruby-1.8.7-p72') => File.join(SRC_DIR, 'ruby-1.8.7-p72.tar.bz2') do
    sh "cd #{SRC_DIR} && " +
      "tar -jxvf ruby-1.8.7-p72.tar.bz2"
  end

  file File.join(SRC_DIR, 'ruby-1.8.7-p72.tar.bz2') do
    sh "cd #{SRC_DIR} && " +
      "curl ftp://ftp.ruby-lang.org/pub/ruby/ruby-1.8.7-p72.tar.bz2 > ruby-1.8.7-p72.tar.bz2"
  end

  file File.join(INCLUDE_DIR, 'readline', 'readline.h') => File.join(SRC_DIR, 'readline-6.0') do
    sh "cd #{File.join(SRC_DIR, 'readline-6.0')} && " +
      "./configure --prefix=#{DEPS_DIR} && " +
      "make -j 3 && make install"
  end

  file File.join(SRC_DIR, 'readline-6.0') => File.join(SRC_DIR, 'readline-6.0.tar.gz') do
    sh "cd #{SRC_DIR} && " +
      "tar -zxvf readline-6.0.tar.gz"
  end

  file File.join(SRC_DIR, 'readline-6.0.tar.gz') do
    sh "cd #{SRC_DIR} && " +
      "curl http://ftp.gnu.org/gnu/readline/readline-6.0.tar.gz > readline-6.0.tar.gz"
  end

  namespace :gems do
    task :gem => [:ruby,GEM_DIR]

    file GEM_DIR => File.join(SRC_DIR, 'rubygems-1.3.1') do
      sh "cd #{File.join(SRC_DIR, 'rubygems-1.3.1')} && " +
        "#{File.join(BIN_DIR, 'ruby')} ./setup.rb && " +
        "#{BIN_DIR}/gem sources -a http://gems.github.com && " +
        "touch #{GEM_DIR}"
    end

    file File.join(SRC_DIR, 'rubygems-1.3.1') => File.join(SRC_DIR, 'rubygems-1.3.1.tgz') do
      sh "cd #{SRC_DIR} && " +
        "tar -zxvf rubygems-1.3.1.tgz"
    end

    file File.join(SRC_DIR, 'rubygems-1.3.1.tgz') do
      sh "cd #{SRC_DIR} && " +
        "curl -L http://rubyforge.org/frs/download.php/45905/rubygems-1.3.1.tgz > rubygems-1.3.1.tgz"
    end
  end
end
