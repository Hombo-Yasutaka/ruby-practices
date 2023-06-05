require 'optparse'
require 'date'

# コマンドラインで指定されたオプション引数の取得
def get_options()
  # 年月の初期化
  year  = 0
  month = 0

  opt = OptionParser.new

  # オプションの登録
  opt.on('-y VAL') {|v| year  = v.to_i }
  opt.on('-m VAL') {|v| month = v.to_i }

  # コマンドラインのparse
  opt.parse(ARGV)
  # 年月がコマンドラインで指定されない場合の対応
  now = Date.today
  if year == 0
    year = now.year
  end
  if month == 0
    month = now.month
  end

  [year, month]
end

# カレンダーのヘッダー(年月と曜日)の表示
def show_header(year, month)
  # 年月の表示
  puts "      #{month}月 #{year}"
  puts "日 月 火 水 木 金 土"
end

# カレンダーの日付の表示
def show_calendar(beginning_of_the_month, end_of_the_month)
  day_of_week = beginning_of_the_month.wday
  # 1日までの空白埋め
  if day_of_week > 0
    print "  " + "   " * (day_of_week - 1)
  end
  now = Date.today
  (1..end_of_the_month.day).each do |day|
    case day_of_week
    when 6 # 土曜日
      print_day = day.to_s.rjust(3, " ") + "\n"
      day_of_week = 0
    when 0 # 日曜日
      print_day = day.to_s.rjust(2, " ")
      day_of_week += 1
    else # 月~金曜日
      print_day = day.to_s.rjust(3, " ")
      day_of_week += 1
    end

    # 今日の日付のハイライト
    if now == Date.new(end_of_the_month.year, end_of_the_month.month, day)
      print "\e[30m\e[47m#{print_day}\e[0m"
    else
      print print_day
    end
 
    # 月末が土曜でない場合、改行を出力する
    if day == end_of_the_month.day && day_of_week != 0
      puts
    end
  end
  puts
end

# コマンドラインで指定された年月を取得する
year, month = get_options

# 月初の日付情報
beginning_of_the_month = Date.new(year, month, 1)
# 月末の日付情報
end_of_the_month   = Date.new(year, month, -1)

# 年月と曜日を表示する
show_header(year, month)

# カレンダーの日付表示
show_calendar(beginning_of_the_month, end_of_the_month)
