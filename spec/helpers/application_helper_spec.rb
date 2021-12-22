require 'rails_helper'

RSpec.describe ApplicationHelper, type: :helper do

  describe "#present" do
    before do
      @user = create(:user_random)
    end

    context 'when a model is provided with no presenter class' do
      it 'should create a default presenter' do
        expect(helper.present(@user).class).to eq(UserPresenter)
      end
    end

    context 'when a model is provided with a non-existant presenter class' do
      it 'should raise an error' do
        expect{helper.present(@user, UserAdminPresenter)}.to raise_error(NameError, 'uninitialized constant UserAdminPresenter')
      end
    end
  end

  describe "#section_path_helper" do
    before do
      @app = double(id: 5)
      @section = double(class_path: 'question_section', name: 'my_section', questionnaire: double(name: 'da_q'))
    end

    context 'when an sba_app is provided' do
      it 'should generate the right path' do
        expect(helper.section_path_helper(@app, @section)).to eq('/sba_applications/5/questionnaires/da_q/question_section/my_section')
      end

      context 'and edit is set to true' do
        it 'should generate the right path' do
          expect(helper.section_path_helper(@app, @section, true)).to eq('/sba_applications/5/questionnaires/da_q/question_section/my_section/edit')
        end
      end
    end

    context 'when sba_app is not provided' do
      it 'should generate the right path' do
        expect(helper.section_path_helper(@section)).to eq('/questionnaires/da_q/question_section/my_section')
      end

      context 'and edit is set to true' do
        it 'should generate the right path' do
          expect(helper.section_path_helper(@section, true)).to eq('/questionnaires/da_q/question_section/my_section/edit')
        end
      end
    end
  end
end
