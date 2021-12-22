class AssignmentFix
  def execute
    # Identifying and fixing Assigmnets that are missing a Review Id. Deleting Orphans.
    assignments = Assignment.where(review_id: nil)
    puts "#{assignments.count} Assignments found without Review Id"
    assignments.each do |assignment|
      # find review
      puts "Processing Assignment id #{assignment.id}"
      r = Review.find_by_current_assignment_id assignment.id
      if r
        puts "Review Found #{r.id}"
        assignment.update_attribute(:review_id, r.id)
      else
        puts "No Review, orphan assignment deleting"
        assignment.destroy!
      end
    end
  end
end
