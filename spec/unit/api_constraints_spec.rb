require 'spec_helper'

require Rails.root.join('lib', 'api_constraints')

describe ApiConstraints do

  let(:req) {
    class Req
      def self.headers
        { 'Accept' => 'application/vnd.sba.v1' }
      end
    end

    Req
  }

  it "should have a new api constraints class" do
    constraint = ApiConstraints.new({version: 1, default: true})
    expect(constraint.version).to eq(1)
    expect(constraint.default).to eq(true)
    expect(constraint.matches?(req)).to eq(true)
  end


  it "should have a new api constraints class" do
    constraint = ApiConstraints.new({version: 2, default: false})
    expect(constraint.version).to eq(2)
    expect(constraint.default).to eq(false)
    expect(constraint.matches?(req)).to eq(false)
  end
end
