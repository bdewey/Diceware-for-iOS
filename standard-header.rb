#!/usr/bin/env ruby

require 'fileutils'

LICENSE =<<EOF
//  Copyright (c) 2014 Brian Dewey <bdewey@gmail.com>
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
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