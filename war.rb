$multiplayer = false    # multiplayer mode
# $multiplayer = true
$simulation = false     # simulation mode
# $simulation = true


class Card

  attr_reader :value, :suite

  def initialize(value, suite)
    @value = value
    @suite = suite
  end

  def to_s
    "[#{@value} of #{@suite}]"
  end



end



class CardDeck

  def initialize
    @size = 52
    @cards = shuffled_deck
  end

  def cards_left
    @cards.count
  end

  def cards_left?
    @cards.count > 0
  end

  def draw_card
    @cards.shift
  end

  def to_s
    @cards.inject("") { |str, item| str + item.to_s + "\n" }.chomp
  end


  private

  def shuffled_deck
    values = [*(2..10)] + ['J', 'Q', 'K', 'A']
    suites = ['Hearts', 'Diamonds', 'Spades', 'Clubs']
    deck = []

    values.each do |card_value|
      suites.each { |suite| deck << Card.new(card_value, suite) }
    end

    deck.shuffle
  end



end



class Player
  attr_reader :name, :hand

  def initialize(name)
    @name = name
    @hand = []
  end

  def take_card(card)
    @hand << card
  end

  def take_cards(*cards)
    cards.each { |card| take_card card }
  end

  def draw_card
    @hand.shift
  end

  def cards_left
    @hand.count
  end

  def cards_left?
    @hand.count > 0
  end



end



class WarGame

  $multiplayer = false if $multiplayer.nil?
  $simulation = false if $simulation.nil?

  def initialize(player1, player2)
    @player1 = player1
    @player2 = player2
    @card_deck = CardDeck.new
    @face_card_order = {"J" => 0, "Q" => 1, "K" => 2, "A" => 3}
  end

  def start
    draw = "draw your card" unless $simulation

    deal_cards

    unless $simulation
      puts "Each player will press -ENTER- when it's their turn to draw a card."
      puts
      sleep 1
      puts "Commence for war..."

    
      [3,2,1].each do |i|
        puts "#{i}..."
        sleep 1
      end
    
      puts
      puts "Cards are dealt, let the war begin!"
      puts
    end

    while all_players_have_cards?
      if @player1.cards_left < 10
        puts
        puts "\t#{@player1.name}, your cards are running out: " \
             "#{@player1.cards_left} cards left."
        puts
      end

      if @player2.cards_left < 10
        puts
        puts "\t#{@player2.name}, your cards are running out: " \
             "#{@player2.cards_left} cards left."
        puts
      end

      unless $simulation
        puts "#{@player1.name}, #{draw}"
        $stdin.gets
      end

      card1 = @player1.draw_card
      puts "#{@player1.name} draws #{card1}"
      puts

      if $multiplayer && !$simulation
        puts "#{@player2.name}, #{draw}"
        $stdin.gets
      end

      card2 = @player2.draw_card
      puts "#{@player2.name} draws #{card2}"

      war_pile = []
      war_happened = false

      while card1.value == card2.value # war!
        unless @player1.cards_left? and @player2.cards_left?
          if @player1.cards_left? or @player2.cards_left? 
            winner = @player1.cards_left? ? @player1 : @player2
            loser  = @player2.cards_left? ? @player1 : @player2

            puts "#{loser.name} ran out of cards."
            puts "#{winner.name} wins by default!"
          else
            puts "There is no resolve."
            puts "Tie!"
          end

          return
        end

        puts
        puts "\tWar!"
        war_happened = true
        war_pile += [card1, card2]

        num_of_cards_to_throw_into_pile = 
          ([@player1.cards_left, @player2.cards_left].min) - 1
              # the "- 1" is to account for one more card to throw down after
              # both players throw into the war pile.

        if num_of_cards_to_throw_into_pile > 3
          num_of_cards_to_throw_into_pile = 3
        end

        puts
        puts "-Players draw #{num_of_cards_to_throw_into_pile} cards-"
        puts
        
        num_of_cards_to_throw_into_pile.times do
          war_pile << @player1.draw_card
          war_pile << @player2.draw_card
        end

        unless $simulation
          puts "#{@player1.name}, #{draw}"
          $stdin.gets
        end

        card1 = @player1.draw_card
        puts "#{@player1.name} draws #{card1}"
        puts
        
        if $multiplayer && !$simulation
          puts "#{@player2.name}, #{draw}"
          $stdin.gets
        end

        card2 = @player2.draw_card
        puts "#{@player2.name} draws #{card2}"
      end #war

      if card1.value.is_a? Numeric and card2.value.is_a? Numeric  
        if card1.value > card2.value
          player1_picks_up_cards = true
          @player1.take_cards card2, card1
          @player1.take_cards *war_pile if war_happened
        else 
          player1_picks_up_cards = false
          @player2.take_cards card1, card2
          @player2.take_cards *war_pile if war_happened
        end
      elsif card1.value.is_a? Numeric     # then player2 has face card
        player1_picks_up_cards = false
        @player2.take_cards card1, card2
        @player2.take_cards *war_pile if war_happened
      elsif card2.value.is_a? Numeric     # then player1 has face card
        player1_picks_up_cards = true
        @player1.take_cards card2, card1
        @player1.take_cards *war_pile if war_happened
      else                                # both cards are face
        if @face_card_order[card1.value] > @face_card_order[card2.value]
          player1_picks_up_cards = true
          @player1.take_cards card2, card1
          @player1.take_cards *war_pile if war_happened
        else
          player1_picks_up_cards = false
          @player2.take_cards card1, card2
          @player2.take_cards *war_pile if war_happened
        end
      end

      puts

      if player1_picks_up_cards
        puts "#{@player1.name} picks up the cards!"
      else
        puts "#{@player2.name} picks up the cards!"
      end

      puts
      puts
    end

    if @player1.cards_left?
      puts "#{@player1.name} won!"
    else
      puts "#{@player2.name} won!"
    end
  end

  def deal_cards
    while @card_deck.cards_left?
      @player1.take_card @card_deck.draw_card
      @player2.take_card @card_deck.draw_card
    end
  end

  def all_players_have_cards?
    @player1.cards_left? && @player2.cards_left?
  end



end