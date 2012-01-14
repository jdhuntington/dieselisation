require 'rubygems'
require 'fileutils'

module ScenarioRunner
  module Formatter
    module_function
    def init(scenario_name)
      @turn_count = 0
      interactive_logfile_path = File.join(Rails.root, 'public', 'scenario-runner')
      @scenario_name = scenario_name
      FileUtils.mkdir_p interactive_logfile_path
      interactive_logfile_filename = [scenario_name, 'html'].join('.')
      @logfile = File.open(File.join(interactive_logfile_path, interactive_logfile_filename), 'w')
      write_interactive_header(interactive_logfile_filename)
    end

    def interactive_logfile_relative_path
      base = File.expand_path(File.join(Rails.root, 'public'))
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
  <link href="/assets/application.css?body=1" media="screen" rel="stylesheet" type="text/css" />
<link href="/assets/bootstrap.css?body=1" media="screen" rel="stylesheet" type="text/css" />
<link href="/assets/overrides.css?body=1" media="screen" rel="stylesheet" type="text/css" />
<link href="/assets/scenario.css?body=1" media="screen" rel="stylesheet" type="text/css" />
</head>
<body>
<div class="container">
<h1>#{@scenario_name}</h1>
<hr />
<h2 class="alt">#{Time.new.to_s}</h2>
<hr />
<h4>Toggle:</h4>
<a href="#" id="toggle-actions">Actions</a>
<a href="#" id="toggle-assertions">Assertions</a>
<a href="#" id="toggle-links">Links</a>
<hr />
      EOF
    end

    def write_interactive_footer
      @logfile.puts <<-EOF
        </div>
        <script src="/assets/application.js" type="text/javascript"></script>
        <script src="/javascripts/scenario.js" type="text/javascript"></script>
        </body></html>
      EOF
    end

    def log_turn username, step_action
      @turn_count += 1
      printf "%3d - %7s: %s\n", @turn_count, username, step_action
      @logfile.puts <<-EOF
        <div class="notice action">
          <span class="username">#{username}</span>
          <span class="description">#{step_action}</action>
        </div>
      EOF
    end

    def game_link game_state
      @logfile.puts <<-EOF
        <div class="game-link"><a href="/scenario/load?gamestate=#{game_state.id}">link</a></div>
      EOF
    end

    def log_assertion actual, expected
      printf "    * %s %25s == %s\n", (' ' * 30), actual, expected
      @logfile.puts <<-EOF
        <div class="assertion success">#{actual} == #{expected}</div>  
      EOF
    end

    def log_failure actual, expected, actual_eval, expected_eval
      puts "Failed assertion! [#{actual} == #{expected} // #{actual_eval} == #{expected_eval}]"
      @logfile.puts <<-EOF
        <div class="assertion error">#{actual} != #{expected} <span class="evaled">#{actual_eval} != #{expected_eval}</span></div>  
      EOF
    end
  end
end
