# frozen_string_literal: true

COLUMN = 3.0

# 返り値はCOLUMN × row_sizeの行列(2次元配列)を想定
def generate_files(input_files)
  # 出力する際の行数
  row_size = (input_files.size / COLUMN).ceil
  files = Array.new(COLUMN) { Array.new(row_size) { '' } }
  input_files.each_with_index do |file, index|
    column = index / row_size
    row = index % row_size
    files[column][row] = file
  end
  files
end

def print_files(files)
  output_files = generate_output_files(files)
  output_files.each do |parts_of_files|
    puts parts_of_files.join('  ')
  end
end

def generate_output_files(files)
  output_files = []
  files.each do |parts_of_files|
    max_length = 0
    parts_of_files.each do |file|
      max_length = file.length if file.length > max_length
    end
    output_files << parts_of_files.map { |file| file.ljust(max_length, ' ') }
  end
  output_files.transpose
end

input_files = Dir.glob('*')

if !input_files.empty?
  files = generate_files(input_files)
  print_files(files)
end
