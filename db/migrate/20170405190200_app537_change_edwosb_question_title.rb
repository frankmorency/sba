class App537ChangeEdwosbQuestionTitle < ActiveRecord::Migration
  def change
    
    q = Question.find_by(name: 'edwosb_biz_equity')
    q.update_attribute('title', 'Your Equity in the Applicant Firm')
    q.save!
    q = Question.find_by(name: 'edwosb_equity_in_other_firms')
    q.update_attribute('title', 'Your Equity in Other Firms')
    q.save!
    q = Question.find_by(name: 'life_insurance_cash_surrender')
    q.update_attribute('title', 'Do you have a life insurance policy that has a cash surrender value?')
    q.save!
    q = Question.find_by(name: 'life_insurance_loan_value')
    q.update_attribute('title', 'What is the current balance of any loans against life insurance?')
    q.save!
    q = Question.find_by(name: 'stocks_bonds')
    q.update_attribute('title', 'Do you have any stocks, bonds or mutual funds?')
    q.save!
  end
end
