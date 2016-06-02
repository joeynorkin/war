require "./war.rb"

system 'clear'

puts "Time for war!"
puts
puts "To play the computer, enter 1"
puts "For two-player multiplayer mode, enter 2"

play_mode = $stdin.gets.chomp.to_i until play_mode == 1 or play_mode == 2

if play_mode == 1
  $multiplayer = false

  puts "What is your name?"
  name = $stdin.gets.chomp

  player1 = Player.new(name)
  player2 = Player.new("Computer")
else
  $multiplayer = true
  
  puts "Player 1, what is your name?"
  player1_name = $stdin.gets.chomp
  puts "Player 2, what is your name?"
  player2_name = $stdin.gets.chomp

  player1 = Player.new(player1_name)
  player2 = Player.new(player2_name)
end

WarGame.new(player1, player2).start