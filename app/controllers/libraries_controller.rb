class LibrariesController < ApplicationController
  def show
    @assets = Asset.where(library_id: current_library.id)
    if params[:sort] && params[:sort].eql?("title_desc")
      @assets = Asset.order("lower(filename) DESC")
    end
    if params[:sort] && params[:sort].eql?("title_asc")
      @assets = Asset.order("lower(filename) ASC")
    end
    if params[:sort] && params[:sort].eql?("created_at_desc")
      @assets = Asset.order("created_at DESC")
    end
    if params[:sort] && params[:sort].eql?("created_at_asc")
      @assets = Asset.order("created_at ASC")
    end
    if params[:filter] && params[:filter].eql?("video")
      @assets = Asset.where(file_type: 0)
    end
    if params[:filter] && params[:filter].eql?("image")
      @assets = Asset.where(file_type: 1)
    end
    if params[:filter] && params[:filter].eql?("audio")
      @assets = Asset.where(file_type: 2)
    end
  end

  def index
    if params[:sort] && params[:sort].eql?("title_desc")
      @assets = Asset.order("lower(filename) DESC")
    end
    if params[:sort] && params[:sort].eql?("title_asc")
      @assets = Asset.order("lower(filename) ASC")
    end
    if params[:sort] && params[:sort].eql?("created_at_desc")
      @assets = Asset.order("created_at DESC")
    end
    if params[:sort] && params[:sort].eql?("created_at_asc")
      @assets = Asset.order("created_at ASC")
    end

    if @libraries.size == 1
      redirect_to library_url(@libraries.first)
    else
      render layout: 'library_dashboard'
    end
  end

  def activity
    @activity = current_library.activities
    @activity_size = current_library.activities.size
    @activity = current_library.activities.paginate(page: params[:page]).order(created_at: :desc)
    if request.xhr?
      render partial: 'shared/activity_list', layout: false
    end
  end

  def info
    if request.xhr?
      render layout: false
    end
  end
end
