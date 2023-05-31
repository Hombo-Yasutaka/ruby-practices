# frozen_string_literal: true

COLUMN = 3.0

def ls_output(files)
  output_arr = []
  file_num = files.size
  # 出力する行数 = ( ファイル数 / COLUMN )の小数点以下切り上げ
  row = (file_num / COLUMN).ceil
  # ループ内の処理でnilを避けるため
  (1..row * COLUMN - files.length).each do
    files.push('')
  end
  # 列数分ループ処理
  (1..COLUMN).each do
    row_arr = []
    max_str_length = files[0].length
    # 行数分ループ処理
    (1..row).each do
      # 取得したファイルを先頭から取り出して格納、取り出すファイルが無くなれば、nilが入る
      file = files.shift
      max_str_length = file.length if file.length > max_str_length
      row_arr.push(file)
    end
    # 列ごとの幅を調節する
    row_arr.map! { |file| file.ljust(max_str_length, ' ') }
    # 列のデータを取得できたので、配列に格納(二次元配列)
    output_arr.push(row_arr)
  end
  # ループから抜けてtranspose(転置)
  output_arr.transpose
end

files = Dir.glob('*')

if !files.empty?
  outputs = ls_output(files)
  outputs.each do |output|
    puts output.join('  ')
  end
end
