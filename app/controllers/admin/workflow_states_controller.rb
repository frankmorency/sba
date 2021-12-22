require "ruby-graphviz"

module Admin
  class WorkflowStatesController < BaseController
    def index
      @states = {
        initial: {
          app: {},
          review: {},
          cert: {},
        },

        annual_review: {
          review: {},
        },

        mpp_annual_report: AnnualReport::STATUSES,
      }

      @classes = {
        app: {
          wosb: CertificateType.find_by(name: "wosb").questionnaire(SbaApplication::INITIAL).start_application(Organization.first).class,
          mpp: CertificateType.find_by(name: "mpp").questionnaire(SbaApplication::INITIAL).start_application(Organization.first).class,
          eight_a: SbaApplication::EightAMaster,
          asmpp: SbaApplication::ASMPPMaster,
        },
        cert: {
          wosb: Certificate::WosbEdwosb,
          mpp: Certificate::Mpp,
          eight_a: Certificate::EightA,
          asmpp: Certificate::ASMPP,
        },
        review: {
          wosb: Review,
          mpp: Review,
          eight_a: {
            initial: Review::EightAInitial,
            annual: Review::EightAAnnualReview,
          },
          asmpp: {
            initial: Review::ASMPPInitial,
          },
        },
        sub_app: SbaApplication::SubApplication,
      }

      @states[:initial][:app][:wosb] = @classes[:app][:wosb].workflow_spec.states.keys.sort
      @states[:initial][:app][:mpp] = @classes[:app][:mpp].workflow_spec.states.keys.sort
      @states[:initial][:app][:eight_a] = @classes[:app][:eight_a].workflow_spec.states.keys.sort
      @states[:initial][:app][:asmpp] = @classes[:app][:asmpp].workflow_spec.states.keys.sort

      @states[:initial][:review][:eight_a] = @classes[:review][:eight_a][:initial].workflow_spec.states.keys.sort
      @states[:annual_review][:review][:eight_a] = @classes[:review][:eight_a][:annual].workflow_spec.states.keys.sort
      @states[:initial][:review][:asmpp] = @classes[:review][:asmpp][:initial].workflow_spec.states.keys.sort
      # @states[:initial][:review][:wosb] = @classes[:review][:wosb][:initial].workflow_spec.states.keys.sort

      @states[:initial][:cert][:wosb] = @classes[:cert][:wosb].workflow_spec.states.keys.sort

      @states[:initial][:cert][:eight_a] = @classes[:cert][:eight_a].workflow_spec.states.keys.sort
      @states[:initial][:cert][:mpp] = @classes[:cert][:mpp].workflow_spec.states.keys.sort
      @states[:initial][:cert][:asmpp] = @classes[:cert][:asmpp].workflow_spec.states.keys.sort

      @states[:initial][:review][:wosb] = @classes[:review][:wosb].workflow_spec.states.keys.sort
      @states[:initial][:review][:mpp] = @classes[:review][:mpp].workflow_spec.states.keys.sort

      @states[:sub_application] = @classes[:sub_app].workflow_spec.states.keys.sort

      if params[:generate]
        Admin::WorkflowDiagram.generate! @classes[:app][:wosb]
        Admin::WorkflowDiagram.generate! @classes[:app][:mpp]
        Admin::WorkflowDiagram.generate! @classes[:app][:eight_a]
        Admin::WorkflowDiagram.generate! @classes[:app][:asmpp]
        Admin::WorkflowDiagram.generate! @classes[:cert][:eight_a]
        Admin::WorkflowDiagram.generate! @classes[:cert][:wosb]
        Admin::WorkflowDiagram.generate! @classes[:cert][:mpp]
        Admin::WorkflowDiagram.generate! @classes[:cert][:asmpp]
        Admin::WorkflowDiagram.generate! @classes[:review][:eight_a][:initial]
        Admin::WorkflowDiagram.generate! @classes[:review][:eight_a][:annual]
        Admin::WorkflowDiagram.generate! @classes[:review][:asmpp][:initial]
        Admin::WorkflowDiagram.generate! @classes[:review][:wosb]
        Admin::WorkflowDiagram.generate! @classes[:review][:mpp]
        Admin::WorkflowDiagram.generate! @classes[:sub_app]
      end
    end
  end
end
