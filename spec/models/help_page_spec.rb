require 'rails_helper'

RSpec.describe HelpPage, type: :model do
  
  context "when a user attempts to add values to the help page" do
    before do 
      @page = HelpPage.new
    end

    describe "the title validation" do
      it 'should fail when a script tag is present' do
        @page.title = "<script src='http://some-bad-url.com/bad-file.js'>Something Goes Here</script>"
        expect(@page.valid?).to eq(false)
      end

      it 'should pass when there are no tags' do
        @page.title = "Some Great title goes here!"
        expect(@page.valid?).to eq(true)
      end

      it 'should pass when there are authorized tags' do
        @page.title = "<p>Some Great title goes here!</p>"
        expect(@page.valid?).to eq(true)
      end
    end

    describe "the left_panel validation" do
      it 'should fail' do
        @page.left_panel = "<script src='http://some-bad-url.com/bad-file.js'>Something Goes Here</script>"
        expect(@page.valid?).to eq(false)
      end

      it 'should pass' do
        @page.left_panel = "Some Great title goes here!"
        expect(@page.valid?).to eq(true)
      end

      it 'should pass when there are authorized tags' do
        @page.left_panel = "<p>Some Great title goes here!</p>"
        expect(@page.valid?).to eq(true)
      end
    end


    describe "the right_panel validation" do
      it 'should fail' do
        @page.right_panel = "<script src='http://some-bad-url.com/bad-file.js'>Something Goes Here</script>"
        expect(@page.valid?).to eq(false)
      end

      it 'should pass' do
        @page.right_panel = "Some Great title goes here!"
        expect(@page.valid?).to eq(true)
      end

      it 'should pass when there are authorized tags' do
        @page.right_panel = "<p>Some Great title goes here!</p>"
        expect(@page.valid?).to eq(true)
      end
    end
  end

end
