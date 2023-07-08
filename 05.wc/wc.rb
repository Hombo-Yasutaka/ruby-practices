# frozen_string_literal: true

require 'optparse'

def parse_options
  opt = OptionParser.new
  options = {
    l: false,
    w: false,
    c: false
  }
  opt.on('-l') { |v| options[:l] = v }
  opt.on('-w') { |v| options[:w] = v }
  opt.on('-c') { |v| options[:c] = v }
  opt.parse!(ARGV)
  options = options.map { |key, _| [key, true] }.to_h if !options.value? true
  options
end

def count_lines(file)
  lines = 0
  file.each do
    lines += 1
  end
  lines
end

def count_words(file)
  words = 0
  file.each do |line|
    words += line.split(' ').length
  end
  words
end

def print_outputs(outputs)
  max_widths = Array.new(outputs[0].length, 0)
  max_widths.each_index do |column|
    max_widths[column] = outputs.transpose[column].max_by(&:length).length
  end
  max_widths[..-2] = max_widths[0..2].map { max_widths[..-2].max }
  outputs.each do |output|
    puts output.map.with_index { |value, column|
      if value == output[-1]
        value
      else
        "#{value.rjust(max_widths[column], ' ')} "
      end
    }.join
  end
end

options = parse_options
outputs = []
total_line = 0
total_word = 0
total_size = 0
if ARGV.empty?
  file = readlines
  byte_size = 0
  file.each do |line|
    byte_size += line.bytesize
  end
  lines = count_lines(file).to_s
  words = count_words(file).to_s
  puts "#{lines.rjust(7, ' ')} #{words.rjust(7, ' ')} #{byte_size.to_s.rjust(7, ' ')}"
else
  ARGV.each do |filepath|
    output = []
    lines = count_lines(File.open(filepath))
    words = count_words(File.open(filepath))
    size = File.open(filepath).size
    total_line += lines
    total_word += words
    total_size += size
    output << lines.to_s if options[:l]
    output << words.to_s if options[:w]
    output << size.to_s if options[:c]
    output << filepath
    outputs << output
  end
  if ARGV.length > 1
    total = []
    total << total_line.to_s if options[:l]
    total << total_word.to_s if options[:w]
    total << total_size.to_s if options[:c]
    total << '合計'
    outputs << total
  end
  print_outputs(outputs)
end
