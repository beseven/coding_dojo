require_relative '../lib/roman_numerals'

describe RomanNumerals do
  def arabic_to_roman_rep(number)
    RomanNumerals.new(number).arabic_to_roman
  end
  
  describe "#arabic_to_roman" do
    {
      1 => ?I,
      2 => 'II',
      3 => 'III',
      4 => 'IV',
      5 => 'V',
      6 => 'VI',
      7 => 'VII',
      8 => 'VIII',
      9 => 'IX',
      10 => 'X',
      20 => 'XX',
      1990 => 'MCMXC',
      2008 => 'MMVIII',
      99 => 'XCIX',
      47 => 'XLVII'
    }.each do |arabic,roman|
      specify "the number #{arabic} should be #{roman}" do
        expect(arabic_to_roman_rep(arabic)).to eq(roman)
      end
    end
  end
end