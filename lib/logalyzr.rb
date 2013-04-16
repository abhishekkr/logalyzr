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


    Arg0::Console.value_for(['-err', '-errors', '--span-errors']).each do |logfile|
      Logalyzr::Mappr.errors_trace_with_timespan logfile
    end
  end
end
