namespace :review do
  task appeal_expired: :environment do
		@reviews_to_close =	 Review::EightAInitial.pending_reconsideration_or_appeal.select(&:close_appeal?)

		@reviews_to_close.each do |review|
			puts "Closing appeal for DUNS: #{review.certificate.organization.duns_number}"
			review.send('close!')
			review.save!
			certificate = review.certificate
			certificate.send('make_ineligible!')
			certificate.save!
		end
  end


  desc "remove current assignment ID on the review if a case is in a terminal state "
  # USAGE: rake review:terminal_states
  task terminal_states: :environment do

    # Reviews that use the terminal states from the base review_workflow concern OR redefine their states and keep the same terminal state names
    Review.with_early_graduated_state.each do |review|
      review.remove_current_assignment
    end

    Review.with_terminated_state.each do |review|
      review.remove_current_assignment
    end

    Review.with_voluntary_withdrawn_state.each do |review|
      review.remove_current_assignment
    end

    # Review types that redefine their states AND use new terminal state names
    Review::EightAInitial.with_closed_state.each do |review|
      review.remove_current_assignment
    end

    Review::ASMPPInitial.with_closed_state.each do |review|
      review.remove_current_assignment
    end
  end
end