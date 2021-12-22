require 'sba_application/master_application'

class SbaApplication::ASMPPMaster < SbaApplication::MasterApplication
  include MasterApplicationWorkflow

  def self.with_valid_cert
    joins(:certificate).where.not('certificates.workflow_state IN (?)', Certificate::ASMPP::NON_ACTIVE_STATES)
  end

  def self.do_supervisor_assigned_cases(user)
    asmpp.with_valid_cert.assigned_workload(user.id)
  end

  def self.do_supervisor_unassigned_cases(user)
    asmpp.not_in_review.with_valid_cert.
        joins(:duty_stations).where('duty_stations.id' => user.duty_stations.map(&:id)).
        order(created_at: :asc)
  end

  def start_review_process(user)
    case kind
    when INITIAL
      reviews << Review::ASMPPInitial.create_and_assign_review(user, self)
    end
    self.ignore_creator = true
    save!
  end
end