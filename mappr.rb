#!/usr/bin/env ruby

lines = File.read(ARGV[0]).split("\n")

months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
          'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec']

def grep_request_id(line)
  line.match(/req[A-Za-z0-9\-]*/).to_s
end

def grep_timestamp(line)
  line.match(/^[A-Z][a-z][a-z]\s*[0-9]\s*[0-9][0-9]\:[0-9][0-9]\:[0-9][0-9]/).to_s
end

def uniq_request_ids(lines)
  lines.collect{|line|
    grep_request_id line
  }.compact.uniq
end

def uniq_timestamps(lines)
  lines.collect{|line|
    grep_timestamp line
  }.compact.uniq
end

def grep_errors(lines, pattern = 'ERROR')
  lines.select{|line|
    line.match(/#{pattern}/)
  }
end

def grep_same_time(lines, time_string)
  lines.select{|line|
    line.match(/#{time_string}/)
  }
end

errors = grep_errors(lines)

timestamps = uniq_timestamps(errors)

request_ids = uniq_request_ids(errors)

#puts timestamps

###trying out mappr
error = errors[0]
error_time = grep_timestamp error
same_time_log = lines.select{|line| line.match(/#{error_time}/)}
puts same_time_log

