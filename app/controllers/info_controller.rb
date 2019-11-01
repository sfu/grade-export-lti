class InfoController < ApplicationController

  def health_check
    # check that we have a valid database connection
    User.connection.select_value("SELECT 1")
    respond_to do |format|
      format.html { render plain: 'ok'}
      format.json { render json: {
        status: 'ok',
        release: release,
        revision: revision
      }}
    end
  end

  private
  def release
    return @release if defined?(@release)
    release_file = "#{Rails.root}/RELEASE"
    @release = if File.file?(release_file)
      File.readlines(release_file).first.try(:strip)
    else
      nil
    end
  end

  def revision
    return @revision if defined?(@revision)
    rev_file = "#{Rails.root}/REVISION"
    @revision = if File.file?(rev_file)
      File.readlines(rev_file).first.try(:strip)
    else
      nil
    end
  end

end
