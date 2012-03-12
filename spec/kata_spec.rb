# describe 'comparing two hands' do
#   specify 'a hand with a higher score wins' do
#     higher = stub
#     lower = stub
#     House.winner_of(higher, lower).should == higher
#   end
# end

class Hand
  def initialize(cards)
    @cards = cards
  end  
  
  def royal_flush?
    straight_flush? && high_card == 12
  end
  
  def flush?
    @cards.map {|c| c[-1]}.uniq.length == 1
  end
  
  def four_of_a_kind?
    n_of_a_kind?(4)
  end
  
  def three_of_a_kind?
    n_of_a_kind?(3)
  end

  def full_house?
    ranks.uniq.length == 2
  end
  
  def straight?
    sorted_ranks = ranks.sort
    return true if sorted_ranks == [0, 1, 2, 3, 12]
    sorted_ranks.last - sorted_ranks.first == 4
  end
  
  def straight_flush?
    straight? && flush?
  end
  
  def pair?
    n_of_a_kind?(2)
  end
  
  def two_pair?
    rank_count.count(2) == 2
  end
  
  def n_of_a_kind?(x)
    rank_count.member? x
  end

  def rank_count
    hash = Hash.new 0
    ranks.each { |c| hash[c] += 1 }
    hash.values
  end

  RANKS = %w(2 3 4 5 6 7 8 9 1 j q k a)
  def ranks
    @cards.map {|c| RANKS.index c[0]}
  end
  
  def high_card
    ranks.sort.last
  end
  
  HAND_RANKS = [:royal_flush, :straight_flush, :four_of_a_kind, :full_house, :flush, :straight, :three_of_a_kind, :two_pair, :pair]
  def type
    HAND_RANKS.find{ |type| self.is_type?(type)}
  end
  
  def hand_rank
    HAND_RANKS.index type
  end
  
  def is_type?(type)
    self.send "#{type}?"
  end
  
end

module House
  class << self
    def winner_of(a,b)
      if a.hand_rank != b.hand_rank
        [a,b].sort_by(&:hand_rank).first
      else
        [a,b].sort_by(&:high_card).last
      end
    end
  end
end

describe Hand do
  
  describe "type" do
    it "should return royal_flush for a royal flush" do
      Hand.new(%w( 10h jh qh kh ah)).type.should == :royal_flush
    end
    it "should return straight_flush for a straight flush" do
      Hand.new(%w(9h 10h jh qh kh)).type.should == :straight_flush
    end
    it "should return four_of_a_kind for a four of a kind" do
      Hand.new(%w(ah as ac ad kh)).type.should == :four_of_a_kind
    end
    it "should return full_house for a full house" do
      Hand.new(%w(ah as ac kd kh)).type.should == :full_house
    end
    it "should return flush for flush" do
      Hand.new(%w(ah 2h 3h 4h kh)).type.should == :flush
    end
    it "should return straight for straight" do
      Hand.new(%w(ah 2h 3h 4c 5h)).type.should == :straight
    end
    it "should return two_pair for two pair" do
      Hand.new(%w(ah as qc kd kh)).type.should == :two_pair
    end
  end
  
  describe "hand type" do
    it "should be flush if all cards are the same suit" do
      hand = Hand.new %w(4h 6h 8h 9h 2h)
      hand.should be_flush
    end
    
    it "knows it is a straight" do
      hand = Hand.new %w( 2h 3d 4h 5d 6s )
      hand.should be_straight
    end
    
    it "knows it is a straight with ace low" do
      hand = Hand.new %w( ah 2d 3h 4d 5s )
      hand.should be_straight
    end
    
    it "is not a straight with non-consecutive cards" do
      hand = Hand.new %w( 2h 3d 9h 5d 6s )
      hand.should_not be_straight
    end
    
    it "should be three of a kind" do
      hand = Hand.new %w( 2h 2d 2s ah 3h)
      hand.should be_three_of_a_kind
    end
    
    it "should be three of a kind" do
      hand = Hand.new %w( ah 2h 2d 2s  3h)
      hand.should be_three_of_a_kind
    end
    
    it "should be a flush if one of them is a 10" do
      hand = Hand.new %w(4h 6h 10h 9h 2h)
      hand.should be_flush
    end
    
    it "should be 4 of kind if theres 4 of a kind" do
      hand = Hand.new %w(as ac ad ah 4s)
      hand.should be_four_of_a_kind
    end
    
    it "should be 4 of kind if the first card isn't one of the 4" do
      hand = Hand.new %w(4s as ac ad ah)
      hand.should be_four_of_a_kind
    end
    
    it "should be 4 of a kind if there are 4 10 cards" do
      hand = Hand.new %w(10s 10c 10d 10h 4s)
      hand.should be_four_of_a_kind
    end
    
    it "should only be a full house if 3 & 2 of a kind" do
      hand = Hand.new %w( qh qd qc kc ks)
      hand.should be_full_house
      hand.should_not be_four_of_a_kind
    end
    
    it "should be a royal flush if the cards are a straight and flush ace high" do
      hand = Hand.new %w( 10h jh qh kh ah)
      hand.should be_royal_flush
    end
    
    it "should be a sraight flush if the cards are a straight and flush" do
      hand = Hand.new %w( 9h 10h jh qh kh)
      hand.should be_straight_flush
    end
    
    it "should be a pair if there are two cards of the same rank" do
      hand = Hand.new %w( 9h 9d jh qc kh)
      hand.should be_pair
    end
    
    it "two pair is two different pairs" do
      hand = Hand.new %w(9h 9s 8h 8d ah)
      hand.should be_two_pair
    end
    
    it "the high card of a hand should be the highest card DUH" do
      hand = Hand.new %w(9h 9s 8h 8d ah)
      hand.high_card.should == 12      
    end
  end
  
  describe "comparing" do
    let(:flush) { Hand.new %w(2h 3h 6h 8h 9h) }
    let(:pair)  { Hand.new %w(7d 7h 8h 9c 3c) }
    
    it "a flush beats a pair" do
      House.winner_of(flush, pair).should == flush
    end
    
    it "a high card flush beats a low card flush" do
      higher_flush = Hand.new %w(10c 8c 7c 1c 6c)
      House.winner_of(flush,higher_flush).should == higher_flush
      House.winner_of(higher_flush,flush).should == higher_flush
    end
  end
  
  
end
