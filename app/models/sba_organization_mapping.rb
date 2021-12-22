class SbaOrganizationMapping

  # LIST OF ROLES NAMES. ALL IN ONE PLACE FOR EASY UPDATE.
  ROLE_NAME_WOSB_ANALYST = "WOSB SBA Analyst"
  ROLE_NAME_EDWOSB_ANALYST = "EDWOSB SBA Analyst"
  ROLE_NAME_WOSB_SUPERVISOR = "WOSB SBA Supervisor"
  ROLE_NAME_EDWOSB_SUPERVISOR = "EDWOSB SBA Supervisor"
  ROLE_NAME_8A_SUPERVISOR = "8(a) SBA Supervisor"
  ROLE_NAME_8A_ANALYST = "8(a) SBA Analyst"
  ROLE_NAME_MPP_ANALYST = "MPP SBA Analyst"
  ROLE_NAME_MPP_SUPERVISOR = "MPP SBA Supervisor"
  ROLE_NAME_OPS_SUPPROT_ADMIN = "SBA Support Administrator"
  ROLE_NAME_OPS_SUPPROT_STAFF = "SBA Support Staff"
  ROLE_NAME_VENDOR_ADMIN = "Vendor Admin"
  ROLE_NAME_VENDOR_EDITOR = "Vendor Editor"
  ROLE_NAME_VENDOR_CONTRIBUTOR = "8(a) Contributor"
  ROLE_NAME_CERTIFY_ADMIN = "Certify System Admin"
  ROLE_NAME_CO = "Federal Contracting Officer"
  ### 8(a) Roles Mappings: 
  # HQ Program
  ROLE_NAME_SBA_PROGRAM_HQ_SUPERVISOR = "8(a) Program SBA Supervisor Headquarter"
  ROLE_NAME_SBA_PROGRAM_HQ_ANALYST = "8(a) Program SBA Analyst Headquarter"
  # HQ Associate Administrator
  ROLE_NAME_SBA_AA_HQ_SUPERVISOR = "8(a) Associate Administrator SBA Supervisor Headquarter"
  # CODS
  ROLE_NAME_SBA_CODS_ANALYST = "8(a) Central Office Duty Station Analyst"
  ROLE_NAME_SBA_CODS_SUPERVISOR = "8(a) Central Office Duty Station Supervisor"
  # Size Review
  ROLE_NAME_SBA_SIZE_SUPERVISOR = "Size Review Supervisor"
  ROLE_NAME_SBA_SIZE_ANALYST = "Size Review Analyst"
  # Office of Personnel Security (OPS)
  ROLE_NAME_SBA_OPS_SUPERVISOR = "Sputervisor at Office of Personnel Security (OPS)"
  ROLE_NAME_SBA_OPS_ANALYST = "Analyst at Office of Personnel Security (OPS)"
  # District Office
  ROLE_NAME_SBA_DO_DIRECTOR = "District Office Director"
  ROLE_NAME_SBA_DO_DEPUTY_DIRECTOR = "District Office Deputy Director"
  ROLE_NAME_SBA_DO_SUPERVISOR = "District Office Supervisor"
  ROLE_NAME_SBA_DO_ANALYST = "District Office Analyst"
  # HQ Continuing Eligibility
  ROLE_NAME_SBA_CE_SUPERVISOR = "HQ Continuing Eligibility Supervisor"
  ROLE_NAME_SBA_CE_ANALYST = "HQ Continuing Eligibility Analyst"
  # HQ Legal
  ROLE_NAME_SBA_LEGAL_SUPERVISOR = "HQ Legal Supervisor"
  ROLE_NAME_SBA_LEGAL_ANALYST = "HQ Legal Analyst"
  # Office of Inspector General (OIG)
  ROLE_NAME_SBA_OIG_SUPERVISOR = "Office of Inspector General (OIG) Supervisor"
  ROLE_NAME_SBA_OIG_ANALYST = "Office of Inspector General (OIG) Analyst"

  BUSINESS_UNITS_CODE_TO_NAMES = {
    "CODS" => "Central Office Duty Station",
    "HQ_PROGRAM" => "SBA Program Headquarter",
    "HQ_AA" => "Associate Administrator Headquarter",
    "SIZE" => "Size Review",
    "OPS" => "Office of Personnel Security (OPS)",
    "DISTRICT_OFFICE" => "District Office",
    "OIG" => "Office of Inspector General (OIG)",
    "HQ_CE" => "HQ Continuing Eligibility",
    "HQ_LEGAL" => "Legal",
    "DISTRICT_OFFICE_DIRECTOR" => "District Director",
    "DISTRICT_OFFICE_DEPUTY_DIRECTOR" => "District Deputy Director"
  }

  ROLES = {"Legacy" => {
      "WOSB" => {"supervisor" => ["sba_supervisor_wosb"], "analyst" => ["sba_analyst_wosb"] },
      "EDWOSB" => {"supervisor" => ["sba_supervisor_wosb"], "analyst" => ["sba_analyst_wosb"] },
      "MPP" => {"supervisor" => ["sba_supervisor_mpp"], "analyst" => ["sba_analyst_mpp"] },
      "8a" => {"supervisor" => ["sba_supervisor_8a"], "analyst" => ["sba_analyst_8a"] },
      "SUPPORT" => { "admin" => ["sba_ops_support_admin"], "staff" => ["sba_ops_support_staff"] },
      "CO" => { "CO" => ["federal_contracting_officer"] },
      "VENDOR" => { "admin" => ["vendor_admin"], "editor" => ["vendor_editor"], "contributor" => ["contributor"] },
      "ADMIN" => { "admin" => ["certify_system_admin"] }
      },

    # New 8(a) roles based on BU
           "CODS" => { "8a" => {"supervisor" => ["sba_supervisor_8a_cods"], "analyst" => ["sba_analyst_8a_cods"] } },
           "HQ_AA" => { "8a" => {"supervisor" => ["sba_supervisor_8a_hq_aa"], "analyst" => ["sba_analyst_8a_hq_aa"] } },
           "HQ_PROGRAM" => { "8a" => {"supervisor" => ["sba_supervisor_8a_hq_program"], "analyst" => ["sba_analyst_8a_hq_program"] } },

          "SIZE" => { "8a" => {"supervisor" => ["sba_supervisor_8a_size"], "analyst" => ["sba_analyst_8a_size"] } },
          "OPS" => { "8a" => {"supervisor" => ["sba_supervisor_8a_ops"], "analyst" => ["sba_analyst_8a_ops"] } },
          "DISTRICT_OFFICE" => { "8a" => {"supervisor" => ["sba_supervisor_8a_district_office"], "analyst" => ["sba_analyst_8a_district_office"] } },
          "DISTRICT_OFFICE_DIRECTOR" => { "8a" => {"supervisor" => ["sba_director_8a_district_office"] } },
          "DISTRICT_OFFICE_DEPUTY_DIRECTOR" => { "8a" => {"supervisor" => ["sba_deputy_director_8a_district_office"] } },
          "OIG" => { "8a" => {"supervisor" => ["sba_supervisor_8a_oig"], "analyst" => ["sba_analyst_8a_oig"] } },
          "HQ_CE" => { "8a" => {"supervisor" => ["sba_supervisor_8a_hq_ce"], "analyst" => ["sba_analyst_8a_hq_ce"] } },
          "HQ_LEGAL" => { "8a" => {"supervisor" => ["sba_supervisor_8a_hq_legal"], "analyst" => ["sba_analyst_8a_hq_legal"] } }

    # I think this is a mistake from the BAs
    # "WOSB" => { "8a" => {"supervisor" => ["sba_supervisor_8a"], "analyst" => ["sba_analyst_8a"] } },
    # "MPP" => { "8a" => {"supervisor" => ["sba_supervisor_8a"], "analyst" => ["sba_analyst_8a"] } },
    # "HUBZONE" => { "8a" => {"supervisor" => ["sba_supervisor_8a"], "analyst" => ["sba_analyst_8a"] } }
  }

  # This is the same hash as the previsous one but we want to have a string that represents the human names 
  ROLES_HUMANIZED = {"Legacy" => {
      "WOSB" => {"supervisor" => ROLE_NAME_WOSB_SUPERVISOR, "analyst" => ROLE_NAME_WOSB_ANALYST },
      "EDWOSB" => {"supervisor" => ROLE_NAME_EDWOSB_SUPERVISOR, "analyst" => ROLE_NAME_EDWOSB_ANALYST },
      "8a" => {"supervisor" => ROLE_NAME_8A_SUPERVISOR, "analyst" => ROLE_NAME_8A_ANALYST },
      "MPP" => {"supervisor" => ROLE_NAME_MPP_SUPERVISOR, "analyst" => ROLE_NAME_MPP_ANALYST },
      "SUPPORT" => { "admin" => ROLE_NAME_OPS_SUPPROT_ADMIN, "staff" => ROLE_NAME_OPS_SUPPROT_STAFF },
      "CO" => { "CO" => ROLE_NAME_CO },
      "VENDOR" => { "admin" => ROLE_NAME_VENDOR_ADMIN, "editor" => ROLE_NAME_VENDOR_EDITOR, "contributor" => ROLE_NAME_VENDOR_CONTRIBUTOR },
      "ADMIN" => { "admin" => ROLE_NAME_CERTIFY_ADMIN }
    },
    "HQ_PROGRAM" => { "8a" => { "supervisor" => ROLE_NAME_SBA_PROGRAM_HQ_SUPERVISOR, "analyst" => ROLE_NAME_SBA_PROGRAM_HQ_ANALYST } },
    "HQ_AA" => { "8a" => {"supervisor" => ROLE_NAME_SBA_AA_HQ_SUPERVISOR }},
    "CODS" => { "8a" => {"supervisor" => ROLE_NAME_SBA_CODS_SUPERVISOR, "analyst" => ROLE_NAME_SBA_CODS_ANALYST } },
    "SIZE" => { "8a" => {"supervisor" => ROLE_NAME_SBA_SIZE_SUPERVISOR, "analyst" =>  ROLE_NAME_SBA_SIZE_ANALYST} },
    "OPS" => { "8a" => {"supervisor" => ROLE_NAME_SBA_OPS_SUPERVISOR, "analyst" =>  ROLE_NAME_SBA_OPS_ANALYST} },
    "DISTRICT_OFFICE" => { "8a" => {"supervisor" => ROLE_NAME_SBA_DO_SUPERVISOR, "analyst" =>  ROLE_NAME_SBA_DO_ANALYST} },
    "DISTRICT_OFFICE_DIRECTOR" => { "8a" => {"supervisor" => ROLE_NAME_SBA_DO_DIRECTOR} },
    "DISTRICT_OFFICE_DEPUTY_DIRECTOR" => { "8a" => {"supervisor" => ROLE_NAME_SBA_DO_DEPUTY_DIRECTOR} },
    "OIG" => { "8a" => {"supervisor" => ROLE_NAME_SBA_OIG_SUPERVISOR, "analyst" =>  ROLE_NAME_SBA_OIG_ANALYST} },
    "HQ_CE" => { "8a" => {"supervisor" => ROLE_NAME_SBA_CE_SUPERVISOR, "analyst" => ROLE_NAME_SBA_CE_ANALYST} },
    "HQ_LEGAL" => { "8a" => {"supervisor" => ROLE_NAME_SBA_LEGAL_SUPERVISOR, "analyst" =>  ROLE_NAME_SBA_LEGAL_ANALYST} }
    # I think this is a mistake from the BAs
    # "WOSB" => { "8a" => {"supervisor" => ["sba_supervisor_8a"], "analyst" => ["sba_analyst_8a"] } },
    # "MPP" => { "8a" => {"supervisor" => ["sba_supervisor_8a"], "analyst" => ["sba_analyst_8a"] } },
    # "HUBZONE" => { "8a" => {"supervisor" => ["sba_supervisor_8a"], "analyst" => ["sba_analyst_8a"] } }
  }

  ROLES_SYSTEM_ROLES_HUMANIZED = {
    # Legacy Roles
    "sba_supervisor_wosb" => ROLE_NAME_WOSB_SUPERVISOR,
    "sba_analyst_wosb" =>  ROLE_NAME_WOSB_ANALYST,
    "sba_supervisor_mpp"  => ROLE_NAME_MPP_SUPERVISOR,
    "sba_analyst_mpp"     => ROLE_NAME_MPP_ANALYST,
    "sba_ops_support_staff" => ROLE_NAME_OPS_SUPPROT_STAFF,
    "sba_ops_support_admin" => ROLE_NAME_OPS_SUPPROT_ADMIN ,
    "federal_contracting_officer" => ROLE_NAME_CO,
    "sba_supervisor_8a" => ROLE_NAME_8A_SUPERVISOR,
    "sba_analyst_8a" => ROLE_NAME_8A_ANALYST,
    "vendor_editor" => ROLE_NAME_VENDOR_EDITOR, 
    "vendor_admin" => ROLE_NAME_VENDOR_ADMIN,
    "certify_system_admin" => ROLE_NAME_CERTIFY_ADMIN,
    "contributor" => ROLE_NAME_VENDOR_CONTRIBUTOR,

    # 8(a) analysts
    "sba_analyst_8a_cods" => ROLE_NAME_SBA_CODS_ANALYST,
    "sba_analyst_8a_hq_program" => ROLE_NAME_SBA_PROGRAM_HQ_ANALYST,
    "sba_analyst_8a_size" => ROLE_NAME_SBA_SIZE_ANALYST,
    "sba_analyst_8a_ops" => ROLE_NAME_SBA_OPS_ANALYST,
    "sba_analyst_8a_district_office" => ROLE_NAME_SBA_DO_ANALYST,
    "sba_analyst_8a_hq_ce" => ROLE_NAME_SBA_CE_ANALYST,
    "sba_analyst_8a_hq_legal" => ROLE_NAME_SBA_LEGAL_ANALYST,
    "sba_analyst_8a_oig" => ROLE_NAME_SBA_OIG_ANALYST,
    
    # 8(a) supervisors
    "sba_supervisor_8a_cods" => ROLE_NAME_SBA_CODS_SUPERVISOR,
    "sba_supervisor_8a_hq_program" => ROLE_NAME_SBA_PROGRAM_HQ_SUPERVISOR,
    "sba_supervisor_8a_hq_aa" => ROLE_NAME_SBA_AA_HQ_SUPERVISOR,
    "sba_supervisor_8a_size" => ROLE_NAME_SBA_SIZE_SUPERVISOR,
    "sba_supervisor_8a_ops" => ROLE_NAME_SBA_OPS_SUPERVISOR,
    "sba_supervisor_8a_district_office" => ROLE_NAME_SBA_DO_SUPERVISOR,
    "sba_director_8a_district_office" => ROLE_NAME_SBA_DO_DIRECTOR,
    "sba_deputy_director_8a_district_office" => ROLE_NAME_SBA_DO_DEPUTY_DIRECTOR,
    "sba_supervisor_8a_hq_ce" => ROLE_NAME_SBA_CE_SUPERVISOR,
    "sba_supervisor_8a_hq_legal" => ROLE_NAME_SBA_LEGAL_SUPERVISOR ,
    "sba_supervisor_8a_oig" => ROLE_NAME_SBA_OIG_SUPERVISOR
  }

  REVERSE_ROLES = {
    "sba_supervisor_wosb" => { "Legacy" => {"WOSB" => ["supervisor"], "EDWOSB" => ["supervisor"] } },
    "sba_analyst_wosb" => { "Legacy" => {"WOSB" => ["analyst"], "EDWOSB" => ["analyst"]} },
    "sba_supervisor_mpp"  => { "Legacy" => { "MPP" => ["supervisor"] } },
    "sba_analyst_mpp"     => { "Legacy" => { "MPP" => ["analyst"] } },
    "sba_ops_support_staff" => { "Legacy" => { "SUPPORT" => ["staff"] } },
    "sba_ops_support_admin" => { "Legacy" => { "SUPPORT" => ["admin"] } },
    "federal_contracting_officer" => { "Legacy" => { "CO" => ["CO"] } },
    "sba_supervisor_8a" => {"Legacy" => {"8a" => ["supervisor"] } },
    "sba_analyst_8a" => {"Legacy" => {"8a" => ["analyst"]} },
    # This need to be checked.
    "vendor_editor" => { "Legacy" => { "VENDOR" => ["editor"] } }, 
    "vendor_admin" => { "Legacy" => { "VENDOR" => ["admin"] } },
    "admin" => { "Legacy" => { "ADMIN" => ["admin"] } },
    "contributor" => { "Legacy" => { "VENDOR" => ["contributor"] } },
    # 8(a) analysts
    "sba_analyst_8a_cods" => { "CODS" => {"8a" => ["analyst"]}},
    "sba_analyst_8a_hq_program" => { "HQ_PROGRAM" => {"8a" => ["analyst"]}},
    "sba_analyst_8a_size" => { "SIZE" => {"8a" => ["analyst"]}},
    "sba_analyst_8a_ops" => { "OPS" => {"8a" => ["analyst"]}},
    "sba_analyst_8a_district_office" => { "DISTRICT_OFFICE" => {"8a" => ["analyst"]}},
    "sba_analyst_8a_hq_ce" => { "HQ_CE" => {"8a" => ["analyst"]}},
    "sba_analyst_8a_hq_legal" => { "HQ_LEGAL" => {"8a" => ["analyst"]}},
    "sba_analyst_8a_oig" => { "OIG" => {"8a" => ["analyst"]}},

    # 8(a) supervisors
    "sba_supervisor_8a_cods" => { "CODS" => {"8a" => ["supervisor"]}},
    "sba_supervisor_8a_hq_program" => { "HQ_PROGRAM" => {"8a" => ["supervisor"]}},
    "sba_supervisor_8a_hq_aa" => { "HQ_AA" => {"8a" => ["supervisor"]}},
    "sba_supervisor_8a_size" => { "SIZE" => {"8a" => ["supervisor"]}},
    "sba_supervisor_8a_ops" => { "OPS" => {"8a" => ["supervisor"]}},
    "sba_supervisor_8a_district_office" => { "DISTRICT_OFFICE" => {"8a" => ["supervisor"]}},
    "sba_director_8a_district_office" => { "DISTRICT_OFFICE_DIRECTOR" => {"8a" => ["supervisor"]}},
    "sba_deputy_director_8a_district_office" => { "DISTRICT_OFFICE_DEPUTY_DIRECTOR" => {"8a" => ["supervisor"]}},
    "sba_supervisor_8a_hq_ce" => { "HQ_CE" => {"8a" => ["supervisor"]}},
    "sba_supervisor_8a_hq_legal" =>  { "HQ_LEGAL" => {"8a" => ["supervisor"]}} ,
    "sba_supervisor_8a_oig" => { "OIG" => {"8a" => ["supervisor"]}}
  }

  class << self

    # this is to handle the new 8a roles.
    # This will assign the correct roles based on the roles_map saved on a user. 
    # We should not manage the access_requests objects attached to the user here because
    # We could end up with the wrong dates for the access request. this method just needs
    # to manage roles. 
    def process_roles(user)
      # this is to allow a user to not have any roles. ( all his roles are revoked )
      
      # Removing all the roles for the current user.
      user.roles.each do |role|
        user.remove_role role.name
      end
      unless user.roles_map.nil?
        user.roles_map.each_pair do |biz_unit, permissions| 
          permissions.each_pair do |program, capasity|
            if ROLES[biz_unit] && ROLES[biz_unit][program]
              capasity.each do |name|
                role_name_list = ROLES[biz_unit][program][name]
                role_name_list.each do |r_name|
                  r = Role.find_by_name(r_name)
                  if r.nil?
                    raise "FAIL ADDING: #{r_name}"
                  else
                    # NO ACCESS REQUEST HERE THIS JUST MANAGES ROLES
                    user.add_role(r.name)
                  end
                end
              end
            end
          end
        end
      end
    end

    # This tests only one hash at the time to make sure it is in the master hash
    def is_roles_hash_correct?(hash)
      # this is to allow a user to not have any roles. ( all his roles are revoked )
      if hash.nil?
        return true
      end
      result = false
      hash.each_pair do |biz_unit, biz_unit_hash|
        biz_unit_hash.each_pair do |program, capaities_list|
          result = false
          if ROLES[biz_unit] && ROLES[biz_unit][program]
            hash[biz_unit][program].each do |role_name|
              if ROLES[biz_unit] && ROLES[biz_unit][program] && ROLES[biz_unit][program][role_name]
                result = true
              else
                result = false
                break
              end
            end
          end
        end
      end
      return result
    end

    # This validates that a user permissions roles has combinaisons that belongs to ROLES
    # This is to ensure that we don't have a user that has permissions that have permissions that have 
    # Been deleted from the master hash.
    def is_user_roles_hash_correct?(user)
      process = is_roles_hash_correct?(user.roles_map)
      return process
    end

    # This will be used by a rake task to bring all the users up to speed with permissions.
    # run .run
    def set_roles_map(user)
      hash = Hash.new
      user.roles.each do |role|
        hash.merge!(REVERSE_ROLES[role.name]) { |k,o,n| o.merge!(n){|k,o,n| Array(o) | Array(n)}} if role && self::REVERSE_ROLES[role.name]
      end
      unless hash.empty?
        user.roles_map = hash
        user.save!
      end
    end

    def process_checkboxes(hash)
      permissions = {}
      hash.each_pair do |key, value|
        if key.to_s.include? "checkbox"
          array = value.split("/")
          permissions.merge!( { array[0] => { array[1] => [array[2]] }} ) {|key, a_val, b_val| a_val.merge b_val }
          is_roles_hash_correct?(permissions)
        end
      end
      return permissions
    end

    def humanize_roles_map(list)
      names = []
      list.each_pair do |biz_unit, permissions| 
        permissions.each_pair do |program, capasity_array|
          if ROLES_HUMANIZED[biz_unit] && ROLES_HUMANIZED[biz_unit][program]
            capasity_array.each do |role_name|
              names <<  ROLES_HUMANIZED[biz_unit][program][role_name]
            end
          end
        end
      end unless list.nil?
      return names.join(", ")
    end

    def add_hash_role(user, opt)
      # if we do have that role there is no point in adding it.
      return true if check_user_has_role(user, opt)
      rmap = {}
      rmap = user.roles_map unless user.roles_map.nil?
      opt.each_pair do |bu, permission|
        permission.each_pair do |program, capasity|
          if rmap[bu] && rmap[bu][program]
            user.roles_map[bu][program] += capasity
          elsif rmap[bu]
            user.roles_map[bu][program] = capasity
          else
            if user.roles_map.nil?
              user.roles_map = opt
            else
              user.roles_map[bu] = opt[bu]
            end
          end
          user.save!
        end
      end     
    end

    def remove_hash_role(user, opt)
      # if we don't have that role there is no point in removing it.
      return true unless check_user_has_role(user, opt)
      rmap = {}
      rmap = user.roles_map unless user.roles_map.nil?

      opt.each_pair do |bu, permission|

        permission.each_pair do |program, capasity|    
          if rmap[bu] && rmap[bu][program]
            user.roles_map[bu][program] -= capasity
            if user.roles_map[bu][program].empty?
              user.roles_map[bu].delete(program)
              if user.roles_map[bu].keys.empty?
                user.roles_map.delete(bu)
                if user.roles_map.keys.empty?
                  user.roles_map = nil
                end
              end
            end
          end    
          user.save!
        end
      end     
    end

    def check_user_has_role(user, opt)
      the_return = false
      rmap = user.roles_map
      return false if rmap.nil?
      opt.each_pair do |bu, permission|
        permission.each_pair do |program, capasity|
          if rmap[bu] && rmap[bu][program] && rmap[bu][program].include?(capasity.first)
            the_return = true
          end
        end
      end     
      return the_return
    end

    def create_roles_hash_from_roles_name_list(hash, list)
      if list.empty?
        return {}
      else
        to_merge = REVERSE_ROLES[list.pop].deep_dup
        create_roles_hash_from_roles_name_list(to_merge, list)
      end
      return hash.merge!( to_merge ) {|k,o,n| o.merge!(n){|k,o,n| Array(o) | Array(n)} }
    end
  end
end
