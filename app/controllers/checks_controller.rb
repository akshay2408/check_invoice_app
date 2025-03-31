class ChecksController < ApplicationController
  require 'base64'
  require 'stringio'

  def index
    respond_to do |format|
      format.html
      format.json do
        render json: checkinvoice.map { |data|
          {
            Date: data.try(:created_at).try(:to_date) || "-",
            Company_Name: data.try(:name) || "-",
            Check_Number: data.try(:check_number) || "-",
            Invoice_Number: data.try(:invoice_numbers) || "-",
            Image: data.image.attached? ? Rails.application.routes.url_helpers.rails_blob_url(data.image, only_path: true) : "-"
          }
        }
      end
    end
  end

  def create
    ActiveRecord::Base.transaction do
      check = Check.create!(company_id: params["company_id"], number: params["check_number"], image_data: params[:image])
      
      invoice_numbers = []
      if params["invoice_numbers"].present?
        invoices = params["invoice_numbers"].split(",").map(&:strip)
        invoices.each do |invoice|
          new_invoice = Invoice.create!(number: invoice, company_id: params["company_id"])
          CheckInvoice.create!(invoice_id: new_invoice.id, check_id: check.id)
          invoice_numbers << invoice
        end
      end
      company_name = Company.find_by(id: params["company_id"]).try(:name)

      flash[:success] = {
        company_name: company_name,
        check_number: check.number,
        invoices: invoice_numbers
      }
      redirect_to root_path
    rescue ActiveRecord::RecordInvalid => e
      flash[:error] = "#{e.message}"
      redirect_to request.referer || root_path
    end
  end

  private
  
  def checkinvoice
    @checkinvoice ||= Check
    .joins(:company, check_invoices: :invoice)
    .select('checks.number AS check_number,checks.created_at AS created_at, companies.name AS name, checks.image, STRING_AGG(invoices.number, \', \') AS invoice_numbers')
    .group('checks.id, companies.name, checks.image, checks.created_at').order('checks.created_at DESC')
  end
end
