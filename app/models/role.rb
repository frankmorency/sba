class Role < ActiveRecord::Base
  has_and_belongs_to_many :users, join_table: :users_roles
  belongs_to :resource, polymorphic: true

  before_destroy :cancel # cause rolify is stupid...

  acts_as_paranoid
  has_paper_trail

  scopify

  validates :resource_type,
            inclusion: { in: Rolify.resource_types },
            allow_nil: true

  private

  def cancel
    false
  end
end
