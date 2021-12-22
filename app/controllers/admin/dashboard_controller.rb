require 'socket'

module Admin
  class DashboardController < BaseController
    def index
      @ip_address = nil
      ip=Socket.ip_address_list.detect {|intf| intf.ipv4_private?}
      @ip_address = ip.ip_address if ip
    end
  end
end
