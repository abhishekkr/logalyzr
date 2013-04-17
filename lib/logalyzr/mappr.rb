#Logalyzr::Mappr
#

module Logalyzr
  module Mappr

    def self.errors_trace(logfile)
      Logalyzr.log_me "Preparing TRACEFILES for #{logfile}..."
      Logalyzr::Greppr.grep_backtrace logfile
    end

    def self.errors_timespan(tracefiles, other_log_files_dirs)
      logfiles = []
      other_log_files_dirs.each{|log_file_dir|
        if File.file? log_file_dir
          logfiles << log_file_dir
        elsif File.directory? log_file_dir
          logfiles << Dir.glob("#{log_file_dir}/*").select{|file_dir|
                        File.file? file_dir }
        end
      }

      Logalyzr.log_me "Spanning TRACEFILES for #{logfile}..."
      Array(tracefiles).each{|tracefile|
        Logalyzr.log_me "Spanning for #{tracefile}..."
        Logalyzr::Greppr.grep_same_time tracefile, logfiles
      }
    end

    def self.errors_trace_with_timespan(logfile)
      errors_trace logfile

      tracefiles  = Logalyzr::FSUtil.log_tracefiles logfile
      logfile_dir = File.dirname logfile
      errors_timespan tracefiles, logfile_dir
    end

    def self.errors_only(path)
      Logalyzr::Greppr.path_grep_pattern path, 'ERROR'
    end
  end
end
