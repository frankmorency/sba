FactoryBot.define do
  factory :current_assignment, class: Assignment do
    association :reviewer, factory: :analyst_user
    association :owner, factory: :analyst_user
    association :supervisor, factory: :analyst_user
  end

  factory :initial_eight_a_cods_assignment, class: Assignment do
    association :reviewer, factory: :eight_a_cods_analyst_user
    association :owner, factory: :eight_a_cods_analyst_user
    association :supervisor, factory: :analyst_user 
    after(:build) do |assignment|
      assignment.review = Review.first
    end
  end
end
