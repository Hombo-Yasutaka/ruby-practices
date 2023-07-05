# frozen_string_literal: true

require 'optparse'
require 'etc'

COLUMN = 3.0

def parse_options
  opt = OptionParser.new
  options = {}
  opt.on('-a') { |v| options[:a] = v }
  opt.on('-l') { |v| options[:l] = v }
  opt.on('-r') { |v| options[:r] = v }
  opt.parse(ARGV)
  options
end

def get_input_files(options)
  input_files = if options[:a]
                  Dir.entries('.').sort
                else
                  Dir.glob('*')
                end
  return input_files unless options[:r]

  input_files.reverse!
end

def determine_file_type(file_info)
  if file_info.file?
    '-'
  elsif file_info.directory?
    'd'
  elsif file_info.symlink?
    'l'
  end
end

def determine_file_permission(file_info)
  permission_binary = format('%b', file_info.mode)[-9..]
  permission_char = ''
  permission_binary.each_char.with_index do |char, index|
    permission_char += if char == '1'
                         case index % 3
                         when 0
                           'r'
                         when 1
                           'w'
                         else
                           'x'
                         end
                       else
                         '-'
                       end
  end
  permission_char
end

def generate_file_details(file)
  file_info = File.lstat(file)
  [
    file_info.nlink.to_s,
    Etc.getpwuid(file_info.uid).name,
    Etc.getpwuid(file_info.gid).name,
    file_info.size.to_s,
    file_info.mtime.strftime('%-m月 %e %H:%M'),
    if file_info.symlink?
      "#{file} -> #{File.readlink(file)}"
    else
      file
    end
  ]
end

def print_files_with_detail(files)
  max_widths = Array.new(7, 0)
  max_widths.each_index do |column|
    max_widths[column] = files.transpose[column].max_by(&:length).length
  end
  files.each do |file_info|
    puts file_info.map.with_index { |info, column|
      case column
      when 1
        "#{info.rjust(max_widths[column], ' ')} "
      when 4
        "#{info.rjust(max_widths[column], ' ')}  "
      when 6
        info.ljust(max_widths[column], ' ')
      else
        "#{info.ljust(max_widths[column], ' ')} "
      end
    }.join
  end
end

# 返り値はrow_size × COLUMNの行列(2次元配列)を想定
def generate_files(input_files)
  # 出力する際の行数
  row_size = (input_files.size / COLUMN).ceil
  files = Array.new(COLUMN) { Array.new(row_size) { '' } }
  input_files.each_with_index do |file, index|
    column = index / row_size
    row = index % row_size
    files[column][row] = file
  end
  files.transpose
end

def print_files(files)
  # 出力する各列の表示幅
  max_widths = Array.new(COLUMN, 0)
  max_widths.each_index do |column|
    max_widths[column] = files.transpose[column].max_by(&:length).length
  end
  files.each do |parts_of_files|
    puts parts_of_files.map.with_index { |file, column| file.ljust(max_widths[column], ' ') }.join('  ')
  end
end

options = parse_options
input_files = get_input_files(options)

return if input_files.empty?

if options[:l]
  blocks = 0
  files = []
  input_files.each do |file|
    file_info = File.lstat(file)
    blocks += file_info.blocks / 2
    files << [
      "#{determine_file_type(file_info)}#{determine_file_permission(file_info)}",
      generate_file_details(file)
    ].flatten
  end
  puts "合計 #{blocks}"
  print_files_with_detail(files)
else
  files = generate_files(input_files)
  print_files(files)
end
