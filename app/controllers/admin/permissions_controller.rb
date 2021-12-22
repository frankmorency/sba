module Admin
  class PermissionsController < BaseController
    def index
      send_file Rails.root.join('spec', 'fixtures', 'permissions', 'sba_permissions.csv')
    end
  end
end
