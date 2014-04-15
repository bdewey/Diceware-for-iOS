#!/usr/bin/env ruby

require 'fileutils'

LICENSE =<<EOF
//  Copyright (c) 2014 Brian Dewey <bdewey@gmail.com>
EOF

if ARGV.length == 0
  raise "You must enter a filespec"
end

FILESPEC = ARGV[0]

Dir.glob(File.join("**", FILESPEC)) do |file|  
  should_output_line = false
  output_any_lines = false
  modified_file = file + ".license"
  File.open(modified_file, "w") do |output_file|
    IO.foreach(file) do |line|
      if line !~ /^\/\/.*$/ then
        should_output_line = true
      end
      if should_output_line && !output_any_lines then
        output_file.write LICENSE
      end
      if should_output_line then
        output_any_lines = true
        output_file.write line
      end
    end
  end
  FileUtils.mv(modified_file, file)
  puts file
end