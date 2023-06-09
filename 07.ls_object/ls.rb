# frozen_string_literal: true

COLUMN = 3.0

# 返り値はCOLUMN × output_rowの行列(2次元配列)を想定
def generate_files_2d(files, output_row)
  files_2d = Array.new(COLUMN) { Array.new(output_row) { '' } }
  files.each_with_index do |file, index|
    column = index / output_row
    row = index % output_row
    files_2d[column][row] = file
  end
  files_2d
end

# 引数filesは、['file1', 'file2', ...]という形を想定
def calculate_max_file_name_length(files)
  files.max_by(&:length).length
end

def align_file_name_length_with_spaces(files, length)
  files.map { |file| file.ljust(length, ' ') }
end

input_files = Dir.glob('*')

if !input_files.empty?
  # 出力する際の行数
  output_row = (input_files.size / COLUMN).ceil
  files_2d = generate_files_2d(input_files, output_row)
  aligned_files_2d = []
  files_2d.each do |files_1d|
    max_length = calculate_max_file_name_length(files_1d)
    aligned_files_2d << align_file_name_length_with_spaces(files_1d, max_length)
  end
  # aligned_files_2d(COLUMN × output_row行列)をCOLUMN列で出力する
  aligned_files_2d.transpose.each do |files_1d|
    puts files_1d.join('  ')
  end
end
