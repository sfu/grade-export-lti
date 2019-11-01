class InfoController < ApplicationController

  def health_check
    respond_to do |format|
      format.html { render plain: 'ok'}
      format.json { render json: {
        status: 'ok',
        release: release
      }}
    end
  end

  private
  def release
    return @release if defined?(@release)
    @revision = if File.file?(Rails.root+"RELEASE")
      File.readlines(Rails.root+"RELEASE").first.try(:strip)
    else
      nil
    end
  end

end
