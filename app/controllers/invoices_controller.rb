class InvoicesController < ApplicationController
  
  def index
    respond_to do |format|
      format.html
      format.json do
        render json: invoices.map { |invoice|
          {
            Invoice_Number: invoice&.invoice_number,
            Company_Name: invoice&.company_name || "-",
            Check_Number: invoice&.check_number || "-"
          }
        }
      end
    end
  end

  private

  def invoices
    @invoices ||= Invoice.joins(:company, check_invoices: :check).select('invoices.number AS invoice_number, companies.name AS company_name, checks.number AS check_number').order('invoices.created_at DESC')
  end
end
