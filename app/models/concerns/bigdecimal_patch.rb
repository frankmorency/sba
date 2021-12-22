module DecimalCastRescueRuby24
  def cast_value(value)
    if value.is_a?(::String)
      begin
        super(value)
      rescue ArgumentError
        BigDecimal(0)
      end
    else
      super(value)
    end
  end
end

ActiveRecord::Type::Decimal.prepend DecimalCastRescueRuby24
