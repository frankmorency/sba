class FinancialSummary
  attr_accessor :assets, :liabilities, :income, :agi,
                :notes_receivable, :notes_payable, :stocks_bonds,
                :real_estate, :other_property, :unpaid_taxes,
                :life_insurance, :contributor, :app

  def initialize(contributor, app)
    @app = app
    @contributor = contributor
    @assets = Assets.new(contributor, app)
    @liabilities = Liabilities.new(contributor, app, @assets)
    @income = Income.new(contributor, app)

    @notes_receivable = NotesReceivable.new(contributor, app)
    @notes_payable = NotesPayable.new(contributor, app)
    @stocks_bonds = StocksBonds.new(contributor, app)
    @real_estate = RealEstate.new(contributor, app)
    @other_property = OtherProperty.new(contributor, app)
    @unpaid_taxes = UnpaidTaxes.new(contributor, app)
    @life_insurance = LifeInsurance.new(contributor, app)
  end
end
