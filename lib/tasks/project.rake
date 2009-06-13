DEPS_DIR = File.expand_path(File.join(File.dirname(__FILE__), '..', '..', 'deps'))
ROOT_DIR = File.expand_path(File.join(File.dirname(__FILE__), '..', '..'))
LIB_DIR = File.join(DEPS_DIR, 'lib')
INCLUDE_DIR = File.join(DEPS_DIR, 'include')
SRC_DIR = File.join(DEPS_DIR, 'src')
BIN_DIR = File.join(DEPS_DIR, 'bin')
PROJECT_BIN_DIR = File.join(ROOT_DIR, 'bin')
PROJECT_CONF = YAML.load_file(File.join(ROOT_DIR, 'config', 'project.yml'))
RUBY_V = PROJECT_CONF['packages']['ruby']
RUBY_MINOR = RUBY_V[0..2]
READLINE_V = PROJECT_CONF['packages']['readline']
RUBYGEMS_V = PROJECT_CONF['packages']['rubygems']
GEM_DIR = File.join(DEPS_DIR, 'lib', 'ruby', 'gems', RUBY_MINOR, 'gems')

desc 'Setup to run before working on project'
task :setup => :build do
  exec "CURRENT_PROJECT='pdxrails' ADDPATH='#{BIN_DIR}:#{PROJECT_BIN_DIR}' #{ENV['SHELL']}"
end

desc 'Build software dev environment dependencies'
task :build => [DEPS_DIR, SRC_DIR, 'build:ruby', 'build:gems', 'prod_gems']

file DEPS_DIR do
  sh "mkdir -pv '#{DEPS_DIR}'"
end

file SRC_DIR => DEPS_DIR do
  sh "mkdir -pv '#{SRC_DIR}'"
end

task :prod_gems do
  sh "#{BIN_DIR}/rake gems:install"
end

namespace :build do
  task :ruby => File.join(BIN_DIR, 'ruby')
  task :readline => File.join(INCLUDE_DIR, 'readline', 'readline.h')

  def add_gem(name, version)
    task_name = name.gsub(/\W/, '_')
    dir_name = File.join(GEM_DIR, "#{name}-#{version}")
    task :gems => ["gems:#{task_name}"]
    namespace :gems do
      task task_name.to_sym => ['gems:gem',dir_name]
      file dir_name do
        sh "#{BIN_DIR}/gem install #{name} -v #{version} -- --with-readline-dir=#{DEPS_DIR}"
      end
    end
  end

  def add_gems(&blk)
    gems = blk.call
    gems.each do |name, version|
      add_gem name, version
    end
  end

  add_gems do
    YAML::load(File.read(ROOT_DIR + "/config/project.yml"))['gems']
  end
  
  file File.join(BIN_DIR, 'ruby') => File.join(SRC_DIR, "ruby-#{RUBY_V}") do
    sh "cd #{File.join(SRC_DIR, "ruby-#{RUBY_V}")} && " +
      "./configure --prefix=#{DEPS_DIR} --with-readline-dir=#{DEPS_DIR} && " +
      "make -j 3 && make install"
  end

  file File.join(SRC_DIR, "ruby-#{RUBY_V}") => ['build:readline', File.join(SRC_DIR, "ruby-#{RUBY_V}.tar.bz2")] do
    sh "cd #{SRC_DIR} && " +
      "tar -jxvf ruby-#{RUBY_V}.tar.bz2"
  end

  file File.join(SRC_DIR, "ruby-#{RUBY_V}.tar.bz2") do
    sh "cd #{SRC_DIR} && " +
      "curl ftp://ftp.ruby-lang.org/pub/ruby/#{RUBY_MINOR}/ruby-#{RUBY_V}.tar.bz2 > ruby-#{RUBY_V}.tar.bz2"
  end

  file File.join(INCLUDE_DIR, 'readline', 'readline.h') => File.join(SRC_DIR, "readline-#{READLINE_V}") do
    sh "cd #{File.join(SRC_DIR, "readline-#{READLINE_V}")} && " +
      "./configure --prefix=#{DEPS_DIR} && " +
      "make -j 3 && make install"
  end

  file File.join(SRC_DIR, "readline-#{READLINE_V}") => File.join(SRC_DIR, "readline-#{READLINE_V}.tar.gz") do
    sh "cd #{SRC_DIR} && " +
      "tar -zxvf readline-#{READLINE_V}.tar.gz"
  end

  file File.join(SRC_DIR, "readline-#{READLINE_V}.tar.gz") do
    sh "cd #{SRC_DIR} && " +
      "curl http://ftp.gnu.org/gnu/readline/readline-#{READLINE_V}.tar.gz > readline-#{READLINE_V}.tar.gz"
  end

  namespace :gems do
    task :gem => [:ruby,GEM_DIR]

    file GEM_DIR => File.join(SRC_DIR, "rubygems-#{RUBYGEMS_V}") do
      sh "cd #{File.join(SRC_DIR, "rubygems-#{RUBYGEMS_V}")} && " +
        "#{File.join(BIN_DIR, 'ruby')} ./setup.rb && " +
        "#{BIN_DIR}/gem sources -a http://gems.github.com && " +
        "touch #{GEM_DIR}"
    end

    file File.join(SRC_DIR, "rubygems-#{RUBYGEMS_V}") => File.join(SRC_DIR, "rubygems-#{RUBYGEMS_V}.tgz") do
      sh "cd #{SRC_DIR} && " +
        "tar -zxvf rubygems-#{RUBYGEMS_V}.tgz"
    end

    file File.join(SRC_DIR, "rubygems-#{RUBYGEMS_V}.tgz") do
      sh "cd #{SRC_DIR} && " +
        "curl -L http://rubyforge.org/frs/download.php/45905/rubygems-#{RUBYGEMS_V}.tgz > rubygems-#{RUBYGEMS_V}.tgz"
    end
  end
end
