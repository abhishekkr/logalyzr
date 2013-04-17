# Logalyzr::Greppr
# [volatile] grep/* logic for log lines
require 'time'

module Logalyzr
  module Greppr
    def self.grep_request_id(line)
      line.match(/req[A-Za-z0-9\-]*/).to_s
    end

    def self.grep_timestamp(line)
      timestamp = line.scan(/^[A-Z][a-z]+\s*[0-9]+\s*[0-9]{2}\:[0-9]{2}:[0-9]{2}/)[0]
      Time.parse timestamp
    end

    def self.grep_pattern(logfile, pattern, outputfile=false)
      axn = lambda{|line|
        target_log = outputfile || Logalyzr::Mappr.target_log(logfile)
        Logalyzr::FSUtil.dump_log(target_log, line) if line.match(/#{pattern}/i)
      }
      Logalyzr::FSUtil.read_big_log logfile, axn
    end

    def self.grep_pattern_path(path, pattern)
      Logalyzr::FSUtil.all_logs(path).each{|log|
        Logalyzr::Greppr.grep_pattern log, pattern
      }
    end

    def self.grep_backtrace(logfile, pids = false)
      pids = %x{grep 'ERROR' #{logfile} | awk '{print $7}' | uniq}.strip unless pids
      pids = pids.split("\n")
      pids.each{|pid|
        file = File.open(logfile, 'r')
        tracefile = Logalyzr::FSUtil.tracefile_name(logfile, pid)
        while line = file.gets
          if line.match(/#{pid}\s*ERROR/)
            Logalyzr::FSUtil.dump_log(tracefile, line)
            while inner_line = file.gets
              break unless inner_line.match(/#{pid}\s*TRACE/)
              Logalyzr::FSUtil.dump_log(tracefile, inner_line)
            end

            Logalyzr.log_me "Preapring #{tracefile}..."
            break
          end
        end
        file.close
      }
    end

    def self.grep_same_time(tracefile, logfiles)
      source_logfile = File.join File.dirname(logfiles[0]), tracefile.split(/_/)[-1]
      logfiles = Array(logfiles)
      logfiles.delete source_logfile

      timestamp = grep_timestamp File.read(tracefile).split("\n")[0]
      time_start = timestamp - 2
      time_stop = timestamp + 2
      logfiles.each{|logfile|
        file = File.open(logfile, 'r')
        Logalyzr::FSUtil.dump_log(tracefile, ">>>>> file: #{logfile}")
        Logalyzr.log_me "Spanning #{tracefile}'s timestamp in #{logfile}..."
        while line = file.gets
          line_timestamp = grep_timestamp line
          if (time_start..time_stop).cover? line_timestamp
            Logalyzr::FSUtil.dump_log(tracefile, line)
          end
        end
        file.close
      }
    end

    def self.grep_by_instance_id(tracefile, logfile, outputfile)
      pattern = "https?\://.*/servers/([a-z0-9\-]{8}\-[a-z0-9\-]{4}\-[a-z0-9\-]{4}\-[a-z0-9\-]{4}\-[a-z0-9\-]{12})"
      ids = File.read(tracefile).scan(/#{pattern}/).flatten
      p ids
      return if ids.empty?
      grep_pattern(logfile, ids[0], outputfile)
    end
  end
end
