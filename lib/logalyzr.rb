#!/usr/bin/env ruby
#
#

logalyzr_all = File.join(File.dirname(File.expand_path __FILE__), '*', '*.rb')
Dir.glob(logalyzr_all).each {|lib| require lib}

module Logalyzr
  class << self
    attr_accessor :verbose, :log
  end

  def self.log_me(msg)
    puts "[+] #{msg}" if @verbose
  end

  def self.analyz
    Logalyzr.verbose = Arg0::Console.switch?(['-v', '--verbose'])
    Logalyzr::FSUtil.output_dir

    Arg0::Console.value_for(['-err', '-errors', '--trace-span-errors']).each do |logfile|
      Logalyzr::Mappr.errors_trace_with_timespan logfile
    end

    Arg0::Console.value_for(['-trace', '--trace-errors']).each do |logfile|
      Logalyzr::Mappr.errors_trace logfile
    end

    Arg0::Console.value_for('-tracebyid').each do |tracefile|
      Logalyzr::Greppr.grep_by_instance_id tracefile,
                              Arg0::Console.value_for(['-from', '--from-dir'])[0],
                              Arg0::Console.value_for(['-to', '--to-dir'])[0]
    end

    Arg0::Console.value_for(['-span', '--span-errors']).each do |tracefile|
      Logalyzr::Mappr.errors_timespan tracefile,
                              Arg0::Console.value_for(['-from', '--from-dir'])
    end

    Arg0::Console.value_for(['-grep', '--grep-pattern']).each do |pattern|
      trail_count = Arg0::Console.value_for(['-trail'])
      trail_count =  trail_count.empty? ? 1 : trail_count[0]
      Logalyzr::Greppr.grep_pattern Arg0::Console.value_for(['-from'])[0],
                                    pattern,
                                    Arg0::Console.value_for(['-to'])[0],
                                    trail_count
    end
  end
end
