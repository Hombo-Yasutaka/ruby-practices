# frozen_string_literal: true

COLUMN = 3.0

# 引数filesは、['file1', 'file2', ...]という形を想定
def generate_output_lines(files)
  output_lines = Array.new(COLUMN) { Array.new(ROW) { '' } }
  convert_2d_array(files, output_lines)
  align_column_width(output_lines)
  output_lines.transpose
end

# 引数output_linesは[ [ 'file1', 'file2' ], [ 'file3', '' ], ...]という形を想定
def align_column_width(output_lines)
  output_lines.each do |line|
    max_str_length = line.max_by(&:length).length
    line.map! { |file| file.ljust(max_str_length, ' ') }
  end
end

# 引数to_2d_arrayはCOLUMN × ROWの二次元配列を想定
def convert_2d_array(from_1d_array, to_2d_array)
  from_1d_array.each_with_index do |file, index|
    column = index / ROW
    row = index % ROW
    to_2d_array[column][row] = file
  end
end

files = Dir.glob('*')

if !files.empty?
  ROW = (files.size / COLUMN).ceil
  generate_output_lines(files).each do |line|
    puts line.join('  ')
  end
end
