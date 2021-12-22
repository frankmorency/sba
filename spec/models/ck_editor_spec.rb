RSpec.describe Ckeditor::Picture, type: :model do
  before do
    @ckp = Ckeditor::Picture.new
  end

  describe "#url_content" do
    it 'should call url with content?' do
      expect(@ckp).to receive(:url).with(:content)
      @ckp.url_content
    end
  end
end