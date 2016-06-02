require 'test/unit'
require './war.rb'


class DeckTest < Test::Unit::TestCase
  def setup
    @deck = CardDeck.new
  end

  def test_there_are_52_cards_in_new_deck
    assert_equal 52, @deck.cards_left
  end

  def test_draw_card_removes_card
    assert_instance_of Card, @deck.draw_card
    assert_equal 51, @deck.cards_left 
  end



end




class PlayerTest < Test::Unit::TestCase
  def setup
    @player = Player.new("Testing the Name")
    @deck = CardDeck.new
  end

  def test_player_has_name
    assert_equal "Testing the Name", @player.name
  end

  def test_player_takes_card
    card = @deck.draw_card
    @player.take_card card
    players_card = @player.draw_card

    assert_equal players_card, card
  end

  def test_player_takes_cards
    cards = []

    5.times {cards << @deck.draw_card}

    @player.take_cards *cards

    assert_equal @player.hand, cards
  end

  def test_cards_left?
    assert !@player.cards_left?
    @player.take_card @deck.draw_card
    assert @player.cards_left?
  end

  def test_cards_left
    5.times { @player.take_card @deck.draw_card }

    assert_equal @player.cards_left, 5
  end

end
