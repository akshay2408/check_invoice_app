require "test_helper"

class CompaniesControllerTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:one)
    sign_in @user
    @company1 = companies(:one)
    @company2 = companies(:two)
  end

  test "should get index as JSON" do
    get companies_path, as: :json
    assert_response :success

    json_response = JSON.parse(@response.body)
    expected_names = [@company2.name, @company1.name]
    assert_equal expected_names, json_response.map { |c| c["name"] }
  end
end
