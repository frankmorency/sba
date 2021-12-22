class UpdatePrepopulatedQuestions < ActiveRecord::Migration
  def change
        Question.reset_column_information

    q1 = Question.get('tpc3_q1')
    q1.update_attribute(:prepopulate, true)
    q1.save!

    q1 = Question.get('corp1_q1')
    q1.update_attribute(:prepopulate, true)
    q1.save!

    q1 = Question.get('corp1_q2')
    q1.update_attribute(:prepopulate, true)
    q1.save!

    q1 = Question.get('corp2_q1')
    q1.update_attribute(:prepopulate, true)
    q1.save!

    q1 = Question.get('corp1_q3')
    q1.update_attribute(:prepopulate, true)
    q1.save!

    q1 = Question.get('corp3_q1')
    q1.update_attribute(:prepopulate, true)
    q1.save!

    q1 = Question.get('corp4_q1')
    q1.update_attribute(:prepopulate, true)
    q1.save!

    q1 = Question.get('corp5_q1')
    q1.update_attribute(:prepopulate, true)
    q1.save!

    q1 = Question.get('partn_q1')
    q1.update_attribute(:prepopulate, true)
    q1.save!

    q1 = Question.get('partn_q2')
    q1.update_attribute(:prepopulate, true)
    q1.save!

    q1 = Question.get('llc_q1')
    q1.update_attribute(:prepopulate, true)
    q1.save!

    q1 = Question.get('llc_q2')
    q1.update_attribute(:prepopulate, true)
    q1.save!

    q1 = Question.get('oper1_q1')
    q1.update_attribute(:prepopulate, true)
    q1.save!

    q1 = Question.get('oper1_q2')
    q1.update_attribute(:prepopulate, true)
    q1.save!

    q1 = Question.get('oper2_q1')
    q1.update_attribute(:prepopulate, true)
    q1.save!

    q1 = Question.get('oper2_q2')
    q1.update_attribute(:prepopulate, true)
    q1.save!

    q1 = Question.get('oper3_q1')
    q1.update_attribute(:prepopulate, true)
    q1.save!

    q1 = Question.get('oper3_q2')
    q1.update_attribute(:prepopulate, true)
    q1.save!

    q1 = Question.get('oper4_q1')
    q1.update_attribute(:prepopulate, true)
    q1.save!

    q1 = Question.get('oper4_q2')
    q1.update_attribute(:prepopulate, true)
    q1.save!

    q1 = Question.get('oper5_q2')
    q1.update_attribute(:prepopulate, true)
    q1.save!

    q1 = Question.get('oper6_q2')
    q1.update_attribute(:prepopulate, true)
    q1.save!
  end
end
