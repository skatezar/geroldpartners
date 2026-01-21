class HomeController < ApplicationController
  def index
    @mandates = Mandate.where(active: true).limit(3)
    @compensation_reports = CompensationReport.all.order(created_at: :desc)
  end
end
