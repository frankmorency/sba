module Exporter
  class IdCompressor
    DIGITS = %w(
      0 1 2 3 4 5 6 7 8 9
      a b c d e f g h i j k l m n o p q r s t u v w x y z
      A B C D E F G H I J K L M N O P Q R S T U V W X Y Z
    )

    BASE = DIGITS.length

    def self.compress(number, length)
      # Raise an error because we can't express the number in length digits, because our maximum base is DIGITS.length
      raise ArgumentError.new("Can't express #{number} in #{length} digits") if (number > BASE**length - 1)

      get_digits(number).reverse.join.rjust(length, '0')
    end

    def self.decompress(string)
      string = string.split(//).reverse
      raise ArgumentError.new("#{string.join} not base #{BASE}") if string.reject { |c| DIGITS.include?(c) }.length > 0

      string.each_with_index.map { |c, i| (BASE ** i) * DIGITS.index(c) }.inject(:+)
    end

    def self.get_digits(number)
      number < BASE ? Array(DIGITS[number]) : Array(DIGITS[number % BASE]) + get_digits(number / BASE)
    end
  end
end
