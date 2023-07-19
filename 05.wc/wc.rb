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
  options = options.map { |key, _| [key, true] }.to_h if !options.value?(true)
  options
end

def print_outputs(outputs)
  digit_nums = []
  outputs.each do |output|
    output[..-2].each do |value|
      digit_nums << value.length
    end
  end
  max_width = digit_nums.max
  outputs.each do |output|
    puts output.map { |value|
      if value == output[-1]
        value
      else
        "#{value.rjust(max_width, ' ')} "
      end
    }.join
  end
end

options = parse_options
outputs = []
if ARGV.empty?
  lines = readlines
  size = lines.sum(&:bytesize)
  line_num = lines.length.to_s
  word_num = lines.sum { |line| line.split(' ').length }.to_s
  puts "#{line_num.rjust(7, ' ')} #{word_num.rjust(7, ' ')} #{size.to_s.rjust(7, ' ')}"
else
  total_line = 0
  total_word = 0
  total_size = 0
  ARGV.each do |filepath|
    output = []
    file = File.read(filepath)
    lines = file.split(/\R/)
    line_num = lines.length
    word_num = lines.sum { |line| line.split(' ').length }
    size = file.size
    total_line += line_num
    total_word += word_num
    total_size += size
    output << line_num.to_s if options[:l]
    output << word_num.to_s if options[:w]
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
