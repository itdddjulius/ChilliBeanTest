class LibrariesController < ApplicationController
  def show
    @assets = Asset.where(library_id: current_library.id)
  end

  def index
    if params[:sort] && params[:sort].eql?("alphabetical")
      @libraries = Library.order("lower(name) DESC")
    else
      @libraries = Library.order("lower(name) ASC")
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
