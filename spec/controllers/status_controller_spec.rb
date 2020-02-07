require 'rails_helper'

RSpec.describe StatusController, type: :controller do
  describe 'test_health' do
    endpoint_test :health
  end

  describe 'test_readiness' do
    endpoint_test :readiness
  end

  private

  def endpoint_test(endpoint, status = :success, matcher = /ok/)
    get endpoint
    assert_response status
    assert_match matcher, response.body.to_s
  end
end
