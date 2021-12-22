class Signature
  attr_accessor :questionnaire, :terms

  def initialize(questionnaire, terms = nil)
    @questionnaire = questionnaire
    @terms = []

    if terms
      terms.each do |term|
        @terms << SignatureTerm.new(term)
      end
    else
      JSON.parse(File.read(path)).each do |term|
        @terms << SignatureTerm.new(term)
      end
    end
  end

  private

  def path
    the_path = Rails.root.join('app', 'views', 'questionnaires', questionnaire.name, 'signature.json')

    if File.exists?(the_path)
      the_path
    elsif questionnaire.certificate_type.present?
      Rails.root.join('app', 'views', 'questionnaires', questionnaire.certificate_type.name, 'signature.json')
    else
      Rails.root.join('app', 'views', 'questionnaires', questionnaire.major_version, 'signature.json')
    end
  end
end
