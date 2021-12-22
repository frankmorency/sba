FactoryBot.define do
  factory :answer_params, class: Hash do
    question_text 'whatever'
    answered_for_type ''
    answered_for_id ''
    attachment 'no_attachments_needed'

    initialize_with { attributes }
  end
end
