# frozen_string_literal: true

COLUMN = 3.0

# 返り値はCOLUMN × row_sizeの行列(2次元配列)を想定
def generate_file_list(files)
  # 出力する際の行数
  row_size = (files.size / COLUMN).ceil
  file_list = Array.new(COLUMN) { Array.new(row_size) { '' } }
  files.each_with_index do |file, index|
    column = index / row_size
    row = index % row_size
    file_list[column][row] = file
  end
  file_list
end

def print_file_list(file_list)
  file_list_for_output = []
  file_list.each do |files|
    max_length = files.max_by(&:length).length
    file_list_for_output << files.map { |file| file.ljust(max_length, ' ') }
  end
  # file_list_for_output(COLUMN × row_size行列)をCOLUMN列で出力する
  file_list_for_output.transpose.each do |files|
    puts files.join('  ')
  end
end

input_files = Dir.glob('*')

if !input_files.empty?
  file_list = generate_file_list(input_files)
  print_file_list(file_list)
end
