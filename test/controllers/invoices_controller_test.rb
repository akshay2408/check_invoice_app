require "test_helper"

class InvoicesControllerTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:one)
    sign_in @user
    @invoice1 = invoices(:one)
    @invoice2 = invoices(:two)
  end

  test "should get index as JSON" do
    get invoices_path, as: :json
    assert_response :success

    json_response = JSON.parse(@response.body)
    expected_names = [@invoice1.name, @invoice2.name]
    assert_equal expected_names, json_response.map { |c| c["name"] }
  end
end
