class InfoController < ApplicationController

  def health_check
    respond_to do |format|
      format.html { render plain: 'ok'}
      format.json { render json: {
        status: 'ok'
      }}
    end
  end

end