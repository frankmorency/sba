require 'rails_helper'

RSpec.describe SbaApplication, type: :model do
  pending ".for_display" do
    context 'eight_a' do
      before do
        @eight_a_draft = create(:eight_a_display_application_initial, workflow_state: 'draft')
        @eight_a_submitted = create(:eight_a_display_application_initial, workflow_state: 'submitted')
        @eight_a_cert = create(:certificate_eight_a)

        @eight_a_submitted.update_attribute(:certificate_id, @eight_a_cert)

        @eight_a_annual_draft = create(:eight_a_display_application_annual, workflow_state: 'draft', certificate: @eight_a_cert)
      end

      context 'initial apps' do
        context 'in draft' do
          it 'should show' do
            expect(SbaApplication.for_display).to include(@eight_a_draft)
          end
        end

        context 'submitted' do
          it 'should NOT show' do
            expect(SbaApplication.for_display).not_to include(@eight_a_submitted)
          end
        end

        context 'returned' do
          before do
            @eight_a_draft.update_attribute(:workflow_state, 'returned')
            @app = @eight_a_draft
          end

          it 'should show' do
            expect(SbaApplication.for_display).to include(@app)
          end
        end

        %w(complete inactive under_review).each do |state|
          context state do
            before do
              @eight_a_draft.update_attribute(:workflow_state, state)
              @app = @eight_a_draft
            end

            it 'should NOT show' do
              expect(SbaApplication.for_display).not_to include(@app)
            end
          end
        end
      end

      context 'annual reviews' do
        context 'in draft' do
          it 'should show' do
            expect(SbaApplication.for_display).to include(@eight_a_annual_draft)
          end
        end

        context 'submitted' do
          before do
            @eight_a_annual_draft.update_attribute(:workflow_state, 'submitted')
            @eight_a_annual_submitted = @eight_a_annual_draft
          end

          it 'should show' do
            expect(@displayables).to include(@eight_a_annual_submitted)
          end
        end

        %w(submitted returned).each do |state|
          context state do
            before do
              @eight_a_annual_draft.update_attribute(:workflow_state, state)
              @app = @app
            end

            it 'should show' do
              expect(SbaApplication.for_display).to include(@app)
            end
          end
        end

        %w(complete inactive under_review).each do |state|
          context state do
            before do
              @eight_a_annual_draft.update_attribute(:workflow_state, state)
              @app = @eight_a_draft
            end

            it 'should NOT show' do
              expect(SbaApplication.for_display).not_to include(@app)
            end
          end
        end
      end
    end

    context 'wosb' do
      before do
        @wosb_draft = create(:wosb_display_application, workflow_state: 'draft')
        @wosb_submitted = create(:wosb_display_application, workflow_state: 'submitted')
        @wosb_cert = create(:certificate_wosb)
        @wosb_submitted.update_attribute(:certificate_id, @wosb_cert)
      end

      context 'in draft' do
        it 'should show' do
          expect(SbaApplication.for_display).to include(@wosb_draft)
        end
      end

      context 'submitted' do
        it 'should NOT show' do
          expect(SbaApplication.for_display).not_to include(@wosb_submitted)
        end
      end

      %w(complete inactive under_review).each do |state|
        context state do
          before do
            @wosb_draft.update_attribute(:workflow_state, state)
            @app = @wosb_draft
          end

          it 'should NOT show' do
            expect(SbaApplication.for_display).not_to include(@app)
          end
        end
      end
    end
  end
end
