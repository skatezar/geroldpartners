class HomeController < ApplicationController
  def index
    @mandates = Mandate.where(active: true).order(created_at: :desc)
    @compensation_reports = CompensationReport.all.order(created_at: :desc)
  end
end
