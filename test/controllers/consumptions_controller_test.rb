require "test_helper"

class ConsumptionsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get consumptions_index_url
    assert_response :success
  end
end
