# frozen_string_literal: true

# スコアを配列の一要素毎に分け、ストライクを10に変換する
result = ARGV[0].split(',').map { |point| point == 'X' ? 10 : point.to_i }

score = 0 # 合計スコア
count_frame = 1 # フレーム数
points_per_frame = [] # フレーム毎のスコア
throw_num = 0 # 投数

result.each.with_index do |point, index|
  throw_num += 1
  points_per_frame.push(point)
  # 10フレーム目
  if count_frame == 10
    # 合計スコアに加算
    score += point
  # 1~9フレームかつストライク
  elsif throw_num == 1 && point == 10
    # 合計スコアに加算、次回と次々回のスコアも加算
    score += points_per_frame.sum + result[index + 1] + result[index + 2]
    count_frame += 1
    throw_num   = 0
    points_per_frame.clear
  # 1~9フレームかつ2投目
  elsif throw_num == 2
    # スペア
    if points_per_frame.sum == 10
      # 次回のスコアも加算
      score += result[index + 1]
    end
    # 合計スコアに加算
    score += points_per_frame.sum
    count_frame += 1
    throw_num   = 0
    points_per_frame.clear
  end
end

puts score
