require "test_helper"

class InvoicesControllerTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:one)
    sign_in @user
    
    @company = companies(:one)
    @check = checks(:one)
    @invoice = invoices(:one)
    @check_invoice = check_invoices(:one)
  end

  test "should get index json" do
    get invoices_url, as: :json
    assert_response :success
    
    json_response = JSON.parse(response.body)
    assert_equal 2, json_response.length
    
    assert_equal "INV123", json_response[0]["Invoice_Number"]
    assert_equal "MyString", json_response[0]["Company_Name"]
    assert_equal 987654, json_response[0]["Check_Number"]
  end
end