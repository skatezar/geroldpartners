class HomeController < ApplicationController
  def index
    @mandates = Mandate.where(active: true).limit(3)
  end
end
