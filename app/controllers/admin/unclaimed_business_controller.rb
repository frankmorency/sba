module Admin
  class UnclaimedBusinessController < BaseController
    def index
      @biz = ActiveRecord::Base.connection.exec_query('select sam.duns, sam.tax_identifier_number, sam.mpin from reference.mvw_sam_organizations sam left outer join sbaone.organizations org on org.duns_number = sam.duns where org.duns_number is null and sam.tax_identifier_type <> \'UnKnown\' and sam.sam_extract_code = \'A\' and sam.mpin <> \'\' and sam.duns <> \'\' Limit 10')
    end
  end
end
