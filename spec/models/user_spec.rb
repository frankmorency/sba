require 'rails_helper'

RSpec.describe User, type: :model do
  it { is_expected.to have_many(:answers) }
  it { is_expected.to have_many(:access_requests) }
  it { is_expected.to have_many(:personnels) }

  describe "#filter_by_duty_stations_and_roles" do
    before do
      @user = create(:user_random)
      @user.add_role :sba_analyst_8a_cods
      dt_sf = DutyStation.find_by(name: 'San Francisco')
      @user.duty_stations << dt_sf
      @filtered_user = User.filter_by_duty_stations_and_roles(['San Francisco'], ['sba_analyst_8a_cods']).first
    end

    it 'should return the original user' do
      expect(@user).to eq(@filtered_user)
    end

    it 'should return user with correct role' do
      expect(@filtered_user.has_role?(:sba_analyst_8a_cods) ).to eq(true)
    end

    it 'should return user associated to correct duty station' do
      expect(@filtered_user.duty_stations.first.name).to eq('San Francisco')
    end

  end

  describe "#duty_station" do
    before do
      @user = create(:user_random)
      @dt_sf = DutyStation.find_by(name: 'San Francisco')
      @dt_kc = DutyStation.find_by(name: 'Kansas City')
      @user.duty_stations << @dt_sf
      @user.duty_stations << @dt_kc
    end

    it 'should return the duty station with the smallest id' do
      expect(@user.duty_station).to eq(@dt_kc)
    end

  end

  describe "#set_answers" do
    before do
      @user = create(:user_random)
      @question_group = create(:am_i_eligible)
      @wosb, @edwosb = setup_am_i_eligible

      @answers = {}
      @question_group.question_presentations.each do |pres|
        case pres.question.question_type
          when QuestionType::Boolean
            @answers[pres.unique_id] = {value: 'yes'}
          when QuestionType::NaicsCode
            @answers[pres.unique_id] = {value: '123456'}
        end
      end

      create_basic_app
      @user.set_answers @answers, sba_application: @app
    end

    it 'should magically turn a hash of question_presentation_ids to responses into anonymous_answers' do
      @user.answers.each do |answer|
        expect(answer).to be_a(Answer)
        expect(answer.question).to be_a(Question)
        expect(['yes', '123456']).to include(answer.display_value)
      end
    end
  end

  describe "#select User types" do
    before do
      @vendor_admin = create(:vendor_user)
      @contributor = create(:contributor_user)
      @sba_user = create(:sba_supervisor_user)
      @sba_analyst_8a_cods_reviewer = create(:eight_a_cods_analyst_user)
      @sba_analyst_8a_cods_owner = create(:eight_a_cods_analyst_user)
    end

    it 'should tell me if I am a vendor admin' do
      expect(@vendor_admin.is_vendor?).to be(true)
      expect(@contributor.is_vendor?).to be(false)
      expect(@sba_user.is_vendor?).to be(false)
    end

    it 'should tell me if I am a contrubtor' do
      expect(@vendor_admin.is_contributor?).to be(false)
      expect(@contributor.is_contributor?).to be(true)
      expect(@sba_user.is_contributor?).to be(false)
    end

    it 'should tell me if I am an Analyst' do
      expect(@vendor_admin.is_sba?).to be(false)
      expect(@contributor.is_sba?).to be(false)
      expect(@sba_user.is_sba?).to be(true)
    end

    it 'should tell me if I am a vendor_admin or contributor' do
      expect(@vendor_admin.is_vendor_or_contributor?).to be(true)
      expect(@contributor.is_vendor_or_contributor?).to be(true)
      expect(@sba_user.is_vendor_or_contributor?).to be(false)
    end
  end

  describe "#if user is oberver in application review" do
    before do
      Certificate.destroy_all
      @vendor_admin = create(:vendor_user)
      @contributor = create(:contributor_user)
      @sba_user = create(:sba_supervisor_user)

      # These 9 next lines will create an 8a application and set it up in a state of a review status
      # TODO -- Look if there is a way to create all this in a method in FactoryBot
      @sba_application = create(:sba_8a_initial_application)
      @assignment = create(:initial_eight_a_cods_assignment)
      @review = create(:review_for_eight_a)
      @review.sba_application = @sba_application
      @review.current_assignment = @assignment
      @review.save(validate: false)
      @sba_application.save(validate: false)
      @cert = @sba_application.certificate
      allow(@cert).to receive(:current_review).and_return @review
      @cert.save(validate: false)
    end

  end

  describe "#from_omniauth" do
    let(:auth) do
      Auth = Struct.new(:info);
      Info = Struct.new(:email, :first_name, :last_name, :max_id, :uuid);
      info = Info.new;
      auth = Auth.new;
      auth.info = info;
      auth
    end

    if Feature.active?(:idp)

    context "existing user" do
      let(:vendor_admin) {create :vendor_admin}

      before do
        auth.info.email = vendor_admin.email
        auth.info.first_name = vendor_admin.first_name
        auth.info.last_name = vendor_admin.last_name
        auth.info.max_id = nil
      end

      it "matches and returns the user" do
          expect(User.from_omniauth(auth)).to eq(vendor_admin)
      end
    end

    context "new user" do

      let(:placeholder_user)  {  User.new( { email: "#{SecureRandom.uuid}@mailinator.com",
                                  first_name: "first", last_name: "last",
                                  uuid:SecureRandom.uuid})
                                }

      before do
        auth.info.email = placeholder_user.email
        auth.info.first_name = placeholder_user.first_name
        auth.info.last_name = placeholder_user.last_name
        auth.info.uuid = placeholder_user.uuid
        auth.info.max_id = nil
      end

      it "creates a new user and returns it" do
          user = User.from_omniauth(auth)
          expect(user.persisted?).to be_truthy
          expect(user.email).to eq(placeholder_user.email)
          expect(user.first_name).to eq(placeholder_user.first_name)
          expect(user.last_name).to eq(placeholder_user.last_name)
          expect(user.uuid).to eq(placeholder_user.uuid)
      end
    end
      end
  end
end
