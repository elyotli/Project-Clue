class DaysController < ApplicationController
  def show
    @day = Day.find(params[:id])
    @topics = @day.topics
  end

end
