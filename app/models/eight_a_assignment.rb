class EightAAssignment < Assignment
  validates :supervisor, presence: false

  private

  def assigned_to_analysts
    # to overide the validation in base class
  end
end