require_relative '../lib/roman_numerals'

describe "Roman Numerals" do
  def arabic_to_roman_rep(number)
    RomanNumerals.new(number).arabic_to_roman
  end
  
  specify '1 should be I' do
    arabic_to_roman_rep(1).should == 'I'
  end
end
