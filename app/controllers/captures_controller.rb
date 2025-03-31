class CapturesController < ApplicationController
  
  def index
    @companies = companies
  end

  def new
    @companies = companies
    render partial: 'capture_form'
  end

  private

  def companies
    companies ||= Company.all
  end
end
