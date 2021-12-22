class UserPresenter < BasePresenter
  def name_with_assigned_cases_count
    "#{name} (#{my_eight_a_cases_count} cases)"
  end
end
