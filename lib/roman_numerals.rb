# Given a positive integer number (eg 42) determine
# its Roman numeral representation as a String (eg "XLII").

class RomanNumerals
  def initialize(number)
    @number = number
    @cache = {}
  end
  
  def arabic_to_roman
    @cache[@number] ||= "".tap do |result|
      current = @number
      {
        'M'  => 1000,
        'CM' => 900,
        'C'  => 100,
        'XC' => 90,
        'L'  => 50,
        'XL' => 40,
        'X'  => 10,
        'IX' => 9,
        'V'  => 5,
        'IV' => 4,
        'I'  => 1,
      }.each do |roman,arabic|
        while current >= arabic do
          result << roman
          current -= arabic
        end
      end
    end
  end
end