# Logalyzr::FSUtil
#

module Logalyzr
  module FSUtil

    def self.target_log(logfile)
      File.join $output_dir, File.basename(logfile)
    end

    def self.tracefile_name(logfile, pid)
      File.join $output_dir, "#{pid}_#{File.basename logfile}"
    end

    def self.log_tracefiles(logfile)
      Dir.glob("#{$output_dir}/*_#{File.basename logfile}")
    end

    def self.output_dir
      argv_output_dir     = Arg0::Console.value_for(['-output-dir', '--output-dir'])
      default_output_dir  = File.expand_path File.join( ENV['HOME'], 'output_logalyzr' )
      $output_dir = argv_output_dir.empty? ? default_output_dir : argv_output_dir[0]
      Dir.mkdir $output_dir unless File.directory? $output_dir
    end

    def self.dump_log(target_log, log)
      file = File.open(target_log, 'a')
      file.puts log
      file.close
    end

    def self.read_big_log(lfile, axn)
      file = File.open(lfile, 'r')
      file.each_line do |curr_line|
        axn.call file, curr_line
      end
      file.close
    end

    def self.all_logs(log_location)
      log_location = File.dirname(log_location) unless File.directory? log_location
      Dir.glob("#{log_location}/*")
    end
  end
end
