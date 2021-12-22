require 'faker'
require 'namey'

module Fake
  class Person
    attr_reader :name, :first_name, :last_name, :gender, :email, :birthdate, :phone

    @@generator = Namey::Generator.new

    GENDERS = %i[female male].freeze
    FAKE_DOMAINS = %w[mailinator.com example.com example.net].freeze

    def initialize
      @gender = GENDERS.sample
      @name = @@generator.generate(type: @gender, frequency: :rare)
      @first_name, @last_name = @name.split(/\s+/, 2)
      @phone = "#{Faker::PhoneNumber.area_code}-#{Faker::PhoneNumber.exchange_code}-#{Faker::PhoneNumber.subscriber_number}"
      # if rand > 0.8
      #   @phone += "x#{Faker::PhoneNumber.extension}"
      # end

      @email = Faker::Internet.user_name(@name, %w(. _ -)) + '@' + FAKE_DOMAINS.sample
      @birthdate = Faker::Date.birthday(18, 65)
    end

    def save_to_db!
      user = User.new(
        first_name: first_name,
        last_name: last_name,
        email: email,
        phone_number: phone,
        password: Faker::Internet.password(16, 32, true, true)
      )
      user.skip_confirmation!
      user.save!
      user
    end

    def to_s
      "#{name} <#{email}>"
    end
  end
end
