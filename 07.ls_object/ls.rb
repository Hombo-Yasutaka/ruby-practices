# frozen_string_literal: true

COLUMN = 3.0

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
    files.each do |parts_of_files|
      max_widths[column] = parts_of_files[column].length if parts_of_files[column].length > max_widths[column]
    end
  end
  files.each do |parts_of_files|
    puts parts_of_files.map.with_index { |file, column| file.ljust(max_widths[column], ' ') }.join('  ')
  end
end

input_files = Dir.glob('*')

if !input_files.empty?
  files = generate_files(input_files)
  print_files(files)
end
