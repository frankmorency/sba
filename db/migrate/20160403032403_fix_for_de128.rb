class FixForDe128 < ActiveRecord::Migration
  def change

      SbaApplication.all.each do |app|
        Rails.logger.warn "DE128 - Restoring sba_application answers for app : #{app.id}"
        user = app.organization.users.first
        @sections = app.sections.where.not(type: 'Section::Template')

        @sections.each do |sec|
          sec.question_presentations.each do | questionp |

            unless questionp.answers.set_for(app, sec.answered_for).first
              Rails.logger.warn "  DE128 - Answer not found for QP: #{questionp.id} - #{questionp.title} , App: #{app.id} - Restoring"

              answers = questionp.answers.only_deleted.where(owner: user, sba_application: app, answered_for: sec.answered_for)
              answers.each do |answer|
                Rails.logger.warn "    DE128 - Answer for #{answer.id} of partner #{answer.answered_for_id} was #{answer.inspect}"
                answer.update_attribute('deleted_at', nil)
                Rails.logger.warn "    DE128 - Answer for #{answer.id} of partner #{answer.answered_for_id} is changed to #{answer.inspect}"
              end

            end
          end
        end
        Rails.logger.warn "DE128 - Restored sba_application answers for app : #{app.id}"
      end

  end
end
