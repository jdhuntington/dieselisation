require 'rubygems'
require 'fileutils'

module ScenarioRunner
  module Formatter
    module_function
    def init scenario_name
      @turn_count = 0
      interactive_logfile_path = File.join(RAILS_ROOT, 'public', 'scenario-runner', scenario_name)
      FileUtils.mkdir_p interactive_logfile_path
      interactive_logfile_filename = [Time.new.strftime("%Y-%m-%d--%H-%M-%S"), 'html'].join('.')
      @logfile = File.open(File.join(interactive_logfile_path, interactive_logfile_filename), 'w')
      write_interactive_header(interactive_logfile_filename)
    end

    def interactive_logfile_relative_path
      base = File.expand_path(File.join(RAILS_ROOT, 'public'))
      full = File.expand_path(@logfile.path)
      full[(base.length + 1) .. -1]
    end

    def terminate
      write_interactive_footer
      STDERR.puts ''
      STDERR.puts "Run the rails server and view http://localhost:3000/#{interactive_logfile_relative_path}"
      STDERR.puts ''
    end


    def write_interactive_header(filename)
      @logfile.puts <<-EOF
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN"
    "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en-us">
<head>
   <meta http-equiv="content-type" content="text/html; charset=utf-8" />
   <title>#{filename}</title>
   <!-- syntax highlighting CSS -->
   <link rel="stylesheet" href="/stylesheets/blueprint/screen.css" type="text/css" />
</head>
<body>
<ol>
      EOF
    end

    def write_interactive_footer
      @logfile.puts "</ol></body></html>"
    end

    def log_turn username, step_action
      @turn_count += 1
      printf "%3d - %7s: %s\n", @turn_count, username, step_action
      @logfile.puts <<-EOF
        <li class="action"><span class="username">#{username}</span> <span class="action">#{step_action}</action></li>  
      EOF
    end

    def log_assertion actual, expected
      printf "    * %s %25s == %s\n", (' ' * 30), actual, expected
      @logfile.puts <<-EOF
        <li class="assertion passed">#{actual} == #{expected}</li>  
      EOF
    end

    def log_failure actual, expected, actual_eval, expected_eval
      puts "Failed assertion! [#{actual} == #{expected} // #{actual_eval} == #{expected_eval}]"
      @logfile.puts <<-EOF
        <li class="assertion failed">#{actual} != #{expected} <span class="evaled">#{actual_eval} != #{expected_eval}</span></li>  
      EOF
    end
  end
end
