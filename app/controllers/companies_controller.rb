class CompaniesController < ApplicationController

  def index
    @companies = Company.order('created_at DESC')
    respond_to do |format|
      format.html
      format.json { render json: @companies, only: [:name] }
    end
  end
end
