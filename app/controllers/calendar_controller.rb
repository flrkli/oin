class CalendarController < ApplicationController
  
  def update
    respond_to do |format|
      format.js
    end
  end
  
end
