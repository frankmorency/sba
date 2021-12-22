class BdmisArchiveQuestionnaire < ActiveRecord::Migration
  def change
    
    #Create Doc Type if it doesn't exist
    DocumentType.create! name: 'BDMIS Archive' unless DocumentType.find_by_name('BDMIS Archive')

    # Find and destroy previous questionnaire
    q = Questionnaire.get('bdmis_archive')
    q.destroy if q

    program = Program.find_by(name: 'eight_a')

    eight_a = Questionnaire::SubQuestionnaire.create! name: 'bdmis_archive', title: 'BDMIS Archive Questionnaire', anonymous: false, program: program, human_name: 'BDMIS Archive'
    eight_a.create_sections! do
      root 'bdmis_archive', 1, title: 'BDMIS Archive' do
        question_section 'bdmis_documents', 0, title: 'BDMIS Documents', first: true do
          null_with_attachment_required 'bdmis_documents', 1, title: 'Here are the documents that were migrated for your business from the BDMIS system.', document_types: 'BDMIS Archive'
        end

        review_section 'review', 1, title: 'Review', submit_text: 'Submit'
      end
    end

    eight_a.create_rules! do
      section_rule 'bdmis_documents', 'review'
    end

    eight_a.sections.where(name: 'review').update_all is_last: true
  end
end

