#!/usr/bin/env ruby
#

require_relative 'greppr'
require_relative 'fsutil'

module Logalyzr
  module Mappr

    def self.target_log(logfile)
      File.join $output_dir, File.basename(logfile)
    end

    def self.all_logs(log_location)
      log_location = File.dirname(log_location) unless File.directory? log_location
      Dir.glob("#{log_location}/*")
    end

    def self.errors_only(path)

      all_logs.each{|log|
        puts "From: #{log}"
        Logalyzr::Greppr.record_errors log
      }
    end

    def self.same_timestamp(path, timestamp)
      all_logs(path).each{|log|
        Logalyzr::Greppr.grep_pattern log, timestamp
      }
    end

  end
end

$output_dir = File.join( File.dirname(__FILE__), 'output_logs' )
Dir.mkdir $output_dir unless File.directory? $output_dir
#Logalyzr::Mappr.same_timestamp ARGV[0], ARGV[1]
#Logalyzr::Greppr.grep_backtrace ARGV[0], ARGV[1]
Logalyzr::Greppr.grep_same_time ARGV[0], ARGV[1]
