# Logalyzr::Greppr
# [volatile] grep/* logic for log lines

module Logalyzr
  module Greppr
    def self.grep_request_id(line)
      line.match(/req[A-Za-z0-9\-]*/).to_s
    end

    def self.grep_timestamp(line)
      require 'time'
      timestamp = line.scan(/^[A-Z][a-z]+\s*[0-9]+\s*[0-9]{2}\:[0-9]{2}:[0-9]{2}/)[0]
      Time.parse timestamp
    end

    def self.uniq_request_ids(lines)
      lines.collect{|line|
        grep_request_id line
      }.compact.uniq
    end

    def self.uniq_timestamps(lines)
      lines.collect{|line|
        grep_timestamp line
      }.compact.uniq
    end

    def self.grep_errors(lines, pattern = 'ERROR')
      lines.select{|line|
        line.match(/#{pattern}/)
      }
    end

    def self.grep_pattern(logfile, pattern)
      axn = lambda{|line|
        target_log = Logalyzr::Mappr.target_log(logfile)
        Logalyzr::FSUtil.dump_log(target_log, line) if line.match(/#{pattern}/i)
      }
      Logalyzr::FSUtil.read_big_log logfile, axn
    end

    def self.grep_backtrace(logfile, pids = false)
      pids = %x{grep 'ERROR' #{logfile} | awk '{print $7}' | uniq}.strip unless pids
      pids = pids.split("\n")
      pids.each{|pid|
        file = File.open(logfile, 'r')
        tracefile = File.join $output_dir, "#{pid}_#{File.basename logfile}"
        while line = file.gets
          if line.match(/#{pid}\s*ERROR/)
            Logalyzr::FSUtil.dump_log(tracefile, line)
            while inner_line = file.gets
              break unless inner_line.match(/#{pid}\s*TRACE/)
              Logalyzr::FSUtil.dump_log(tracefile, inner_line)
            end
            break
          end
        end
        file.close
      }
    end

    def self.grep_same_time(tracefile, log_path)
      source_logfile = File.join log_path, tracefile.split(/_/)[-1]
      logfiles = Dir.glob("#{log_path}/*")
      logfiles.delete source_logfile

      timestamp = grep_timestamp File.read(tracefile).split("\n")[0]
      time_start = timestamp - 2
      time_stop = timestamp + 2
      logfiles.each{|logfile|
        file = File.open(logfile, 'r')
        Logalyzr::FSUtil.dump_log(tracefile, ">>>>> file: #{logfile}")
        while line = file.gets
          line_timestamp = grep_timestamp line
          if (time_start..time_stop).cover? line_timestamp
            Logalyzr::FSUtil.dump_log(tracefile, line)
          end
        end
        file.close
      }
    end
  end
end
