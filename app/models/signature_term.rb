class SignatureTerm
  attr_accessor :text, :processed_text

  def initialize(text)
    @text = text
  end

  def process(bind)
    ERB.new(text).result(bind)
  end
end
