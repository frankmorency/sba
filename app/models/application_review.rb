class ApplicationReview < Review
  belongs_to  :sba_application

  validates :sba_application, presence: true
end
