class PersonalSummary
  attr_accessor :assets, :liabilities, :income, :agi, :business_partner

  def initialize(business_partner, has_agi, sba_application_id)
    @business_partner = business_partner
    @assets = Assets.new(business_partner, sba_application_id)
    @liabilities = Liabilities.new(business_partner, @assets, sba_application_id)
    @income = Income.new(business_partner, sba_application_id)
    @agi = AGI.new(business_partner, has_agi, sba_application_id)
  end
end
