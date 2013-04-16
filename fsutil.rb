# Logalyzr::FSUtil
#

module Logalyzr
  module FSUtil

    def self.dump_log(target_log, log)
      file = File.open(target_log, 'a')
      file.puts log
      file.close
    end

    def self.read_big_log(lfile, axn)
      file = File.open(lfile, 'r')
      file.each_line do |curr_line|
        axn.call curr_line
      end
      file.close
    end
  end
end
