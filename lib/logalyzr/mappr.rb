#Logalyzr::Mappr
#

module Logalyzr
  module Mappr

    def self.errors_trace_with_timespan(logfile)
      Logalyzr.log_me "Preparing TRACEFILES for #{logfile}..."
      Logalyzr::Greppr.grep_backtrace logfile

      logfile_dir = File.dirname logfile
      Logalyzr.log_me "Spanning TRACEFILES for #{logfile}..."
      Logalyzr::FSUtil.log_tracefiles(logfile).each{|tracefile|
        Logalyzr.log_me "Spanning for #{tracefile}..."
        Logalyzr::Greppr.grep_same_time tracefile, logfile_dir
      }
    end

    def self.errors_only(path)
      Logalyzr::Greppr.path_grep_pattern path, 'ERROR'
    end
  end
end
