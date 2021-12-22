module Loader
  class EightASubApp < Base
    def initialize(app_id)
      @sub_app  = SbaApplication.find(app_id)
      @app  = @sub_app.master_application
      set_up
    end

    def load!
      SbaApplication.transaction do
        finish_sub_app! @sub_app
      end
    end
  end
end