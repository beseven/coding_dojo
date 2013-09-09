require_relative '../lib/roman_numerals'

describe "Roman Numerals" do
  def arabic_to_roman_rep(number)
    RomanNumerals.new(number).arabic_to_roman
  end
  
  specify 'true should be true' do
    arabic_to_roman_rep("blah").should be_true
  end
end
