# This is a simulation of the card game war between Peter and Jessica

require "./war.rb"

$simulation = true

peter = Player.new("Peter")
jessica = Player.new("Jessica")

WarGame.new(peter, jessica).start
