class AnnualReview8aReminderMailerPreview  < ActionMailer::Preview

	def first_reminder
		AnnualReview8aReminderMailer.first_reminder(Organization.first, Date.today, "mike@mike.com")
	end

	def second_reminder
		AnnualReview8aReminderMailer.second_reminder(Organization.first, Date.today, "mike@mike.com")
	end
end