require 'date'

# █████████████████████████
# █     █ ███ ██    ██    █
# █ █ █ █ ███ ██ █████ ████
# █ █ █ █ ███ ██    ██    █
# █ █ █ █ ███ █████ ██ ████
# █ ███ █     ██    ██    █
# █████████████████████████

PATTERN = <<-EOF.split("\n").map{|line| line.split(//)}.transpose.map(&:join).join
XXXXXXXXXXXXXXXXXXXXXXXXX
X     X XXX XX    XX    X
X X X X XXX XX XXXXX XXXX
X X X X XXX XX    XX    X
X X X X XXX XXXXX XX XXXX
X XXX X     XX    XX    X
XXXXXXXXXXXXXXXXXXXXXXXXX
EOF


MASK = PATTERN.split(//).map{|c| c == 'X'}

DAYSTART = Date.new(2018,1,1)
# puts DAYSTART.wday
raise unless DAYSTART.wday == 1 #
DAYEND   = DAYSTART + (PATTERN.size*8)


# def test_pattern
#   (0..6).map{|n| (PATTERN.split(//)*3).each_with_index{|c,i| print c if i%7==n}; print "\n"}
# end

dates = DAYSTART.upto( DAYEND ).to_a

def on?(date)
  delta = (date - DAYSTART).to_i
  MASK[ delta % MASK.size ]
end

commit_dates = []
dates.each do |date|
  if on?(date)
    22.times{|i| commit_dates << date.to_time + i*3600}
  end
end

str_commit_dates = commit_dates.map(&:to_s)

commit_dates.each do |date|
  puts date
  File.open('random_list_of_dates', 'w') { |f| f << str_commit_dates.shuffle.first(12).join("\n") }
  `GIT_AUTHOR_DATE="#{date}" GIT_COMMITTER_DATE="#{date}" git commit -am "#{date}"`
end

