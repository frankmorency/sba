module Fake
  class Questionnaire
    attr_reader :organization, :fake_business

    def initialize(organization:, fake_business:)
      @organization = organization
      @fake_business = fake_business
    end

    def save_to_db!
      questionnaire = ::Questionnaire::EightAInitial.where(name: "eight_a_initial").first
      app = questionnaire.start_application(organization)
      app.save!
      # now we need to fill in the blanks
      Loader::EightA.load(app.id)
      app
    end
  end
end
