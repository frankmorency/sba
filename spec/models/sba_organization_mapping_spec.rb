require 'rails_helper'

RSpec.describe SbaOrganizationMapping, type: :model do
  
  before(:each) do
    # Creating the roles in the database.
    FactoryBot.create :sba_supervisor_wosb_role
    FactoryBot.create :sba_supervisor_mpp_role
    FactoryBot.create :sba_analyst_mpp_role
    FactoryBot.create :sba_ops_support_admin_role
    FactoryBot.create :sba_ops_support_staff_role
    FactoryBot.create :vendor_admin_role
    FactoryBot.create :vendor_editor_role
    FactoryBot.create :sba_analyst_8a_cods_role
    FactoryBot.create :sba_supervisor_8a_cods_role

    user = FactoryBot.create :analyst_user
    user.update_attribute :confirmed_at, Time.now
    user.add_role :sba_supervisor_wosb
    @user = user

    user = FactoryBot.create :federal_contracting_officer
    user.roles_map = { "Legacy" => { "CO" => ["CO"] } }
    @co_user = user
  end

  context "SbaOrganizationMapping" do

    it "should makes sure that the master hash is a superset of user hash. if not raise" do
      # I make sure that the current assignment is correct
      expect(SbaOrganizationMapping::is_user_roles_hash_correct?(@co_user)).to be(true)

      # I check that the check_roles_hash method will let you know when something is wrong
      expect(SbaOrganizationMapping::is_roles_hash_correct?({ "Legacy" => { "CO" => ["XX"] } })).to be(false)
      
      # I am trying to assign something bad and the system should reject it by setting the roles_map to nil and removing all the roles
      @co_user.roles_map = { "Legacy" => { "CO" => ["XX"] } }
      @co_user.save
      expect(@co_user.roles_map).to be(nil)
      expect(@co_user.roles.size).to be(0)

      expect(SbaOrganizationMapping::is_roles_hash_correct?({"Legacy"=>{"WOSB"=>["supervisor", "analyst"], "EDWOSB"=>["supervisor", "analyst"], "VENDOR"=>["admin"]}})).to be(true)
      expect(SbaOrganizationMapping::is_roles_hash_correct?({"CODS"=>{"8a"=>["analyst", "supervisor"]}})).to be(true)
    end

    it "should check that creating user.roles_map create the json correctly", type: :model do
      @user.add_role :vendor_editor
      SbaOrganizationMapping::set_roles_map(@user)
      expect( (@user.roles_map.to_a - {"Legacy"=>{"WOSB"=>["analyst", "supervisor"], "EDWOSB"=>["analyst", "supervisor"], "VENDOR"=>["editor"]}}.to_a).size ).to eq(0)
    end

    it "should change the roles by changing the value of user.roles_map, this also tests that the obsever on roles_map works" do 
      # Test when a user has one role in the system
      SbaOrganizationMapping::set_roles_map(@co_user)
      expect((@co_user.roles.map{|r| r.name} - ["federal_contracting_officer"]).size).to eq(0)
      # Testing when a user has multiple roles
      @co_user.roles_map = { "Legacy" => { "CO" => ["CO"], "WOSB" => ["analyst"] } }
      
      @co_user.save!

      expect((@co_user.roles.map{|r| r.name} - ["federal_contracting_officer", "sba_analyst_wosb"]).size).to eq(0)
    end

    it "should check that a params hash that comes from roles access page is valid" do
      # Test a valid case
      params_hash = { "checkbox_Legacy/SUPPORT/admin" => "Legacy/SUPPORT/admin" }
      expect((SbaOrganizationMapping::process_checkboxes( params_hash ).to_a - [["Legacy", {"SUPPORT"=>["admin"]}]]).size).to eq(0)

      # Test an invalid case
      params_hash = { "Legacy/SUPPORT/admin" =>"Legacy/SUPPORT/admin"}
      expect(SbaOrganizationMapping::process_checkboxes( params_hash ).to_a.size).to be(0)

      # Test multiple valid cases
      params_hash = { "checkbox_Legacy/SUPPORT/admin" =>"Legacy/SUPPORT/admin", "checkbox_Legacy/MPP/analyst" =>"Legacy/MPP/analyst"}  
      expect((SbaOrganizationMapping::process_checkboxes( params_hash ).to_a - [["Legacy", {"SUPPORT"=>["admin"], "MPP"=>["analyst"]}]]).size).to be(0)

      # Test an invalid case with a valid case
      params_hash = { "checkbox_Legacy/SUPPORT/admin" =>"Legacy/SUPPORT/admin", "Legacy/MPP/analyst" =>"Legacy/MPP/analyst"}  
      expect((SbaOrganizationMapping::process_checkboxes( params_hash ).to_a - [["Legacy", {"SUPPORT"=>["admin"]}]]).size).to be(0)
    end

    it "should humanize the names of the ROLES hash" do 
      string = "Federal Contracting Officer"
      expect(SbaOrganizationMapping::humanize_roles_map(@co_user.roles_map)).to eq(string)
      string = "Federal Contracting Officer, WOSB SBA Analyst"
      hash = { "Legacy" => { "CO" => ["CO"], "WOSB" => ["analyst"] } }
      expect(SbaOrganizationMapping::humanize_roles_map(hash)).to eq(string) 
    end

    it "should add or remove multiple 8(a) roles to a person" do 
      @user.roles_map = {"CODS" => {"8a" => ["analyst"]}}
      @user.save!
      expect( (@user.roles_map.to_a - {"CODS"=>{"8a"=>["analyst"]}}.to_a).size ).to eq(0)

      # Testing adding a Role
      @user.add_hash_role( {"CODS"=>{"8a"=>["supervisor"]} })
      expect( (@user.roles_map.to_a - {"CODS"=>{"8a"=>["analyst", "supervisor"]}}.to_a).size ).to eq(0)

      # Testing removing a Role
      @user.remove_hash_role( {"CODS"=>{"8a"=>["supervisor"]}} )
      expect( (@user.roles_map.to_a - {"CODS"=>{"8a"=>["analyst"]}}.to_a).size ).to eq(0)
    end
  end

end

