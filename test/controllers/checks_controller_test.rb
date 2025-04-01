require "test_helper"
require 'base64'
require 'stringio'

class ChecksControllerTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:one)
    sign_in @user
    @company = companies(:one)
    @check = checks(:one) 
    @invoice = invoices(:one)
    @check_invoice = check_invoices(:one)
  end

  test "should get index as JSON" do
    get checks_path, as: :json
    assert_response :success
    json_response = JSON.parse(@response.body)

    response_data = json_response.find { |data| data["Check_Number"] == @check.number }
    
    assert_not_nil response_data, "Check data not found in response"

    assert_equal @check.created_at.to_date.to_s, response_data["Date"]
    assert_equal @company.name, response_data["Company_Name"]
    assert_equal @check.number, response_data["Check_Number"]
    assert_equal @invoice.number, response_data["Invoice_Number"]
    
    if @check.image.attached?
      assert_match /rails_blob_url/, response_data["Image"]
    else
      assert_equal "-", response_data["Image"]
    end
  end

  test "should create check with valid params" do
    assert_difference 'Check.count', 1 do
      post checks_path, params: {
        company_id: @company.id,
        check_number: 123456,
        image: "data:image/png;base64,#{Base64.strict_encode64(File.read(Rails.root.join('test/fixtures/files/emoji.png')))}",
        invoice_numbers: 'INV123, INV124'
      }
    end
    assert_redirected_to root_path
    follow_redirect!
    assert_not flash[:success]
  end

  test "should create check with valid params but no invoices" do
    assert_difference 'Check.count', 1 do
      post checks_path, params: {
        company_id: @company.id,
        check_number: 654321,
        image: "data:image/png;base64,#{Base64.strict_encode64(File.read(Rails.root.join('test/fixtures/files/emoji.png')))}"
      }
    end
    assert_redirected_to root_path
    follow_redirect!
    assert_not flash[:success].empty?
  end

  test "should not create check with invalid params" do
    assert_no_difference 'Check.count' do
      post checks_path, params: {
        company_id: @company.id,
        check_number: '',
        image: nil
      }
    end
    assert_redirected_to root_path
    follow_redirect!
    assert_not flash[:error].empty?
  end
end
