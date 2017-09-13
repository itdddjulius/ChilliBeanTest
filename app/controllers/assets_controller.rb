class AssetsController < ApplicationController
  def new
    @asset = current_library.assets.build
    render layout: 'upload'
  end

  def show
    @asset = current_library.assets.find(params[:id])
  end

  def edit
  end

  def update
    @asset = current_library.assets.find(params[:id])

    if @asset.update_attributes(asset_params)
      flash[:notice] = "Asset Updated" unless request.xhr?
      log_update(@asset)
    else
      flash[:error] = "Could not update asset for the following reasons: #{@asset.errors.full_messages.to_sentence}" unless request.xhr?
    end

    respond_to do |format|
      format.html { redirect_to library_asset_path(current_library, @asset)}
      format.json { render json: @asset.to_json(include: :asset_infos) }
    end
  end

  def destroy
  end

  def activity
    @asset = current_library.assets.find(params[:id])
    @activity_size = AssetActivity.where(activity_object_id: @asset.id).size
    @activity = AssetActivity.where(activity_object_id: @asset.id).paginate(page: params[:page]).order(created_at: :desc)

    if request.xhr?
      render partial: 'shared/activity_list', layout: false
    end
  end

  def download
    if request.xhr?
      render layout: false
    end
  end

  def delete
    if request.get?
      if request.xhr?
        render layout: false
      end
    elsif request.delete?
      redirect_url = library_path(current_library)

      if !params[:asset_ids]
        if request.xhr?
          render plain: "not ok"
        else
          flash[:notice] = "Error: Assets not Deleted"
          redirect_to redirect_url
        end
        return
      end

      params[:asset_ids].each do |id|
        if id
          asset = Asset.find(id)
          asset.destroy
          log_delete(asset)
        end
      end

      if request.xhr?
        render plain: "ok"
      else
        flash[:notice] = "Assets Deleted"
        redirect_to redirect_url
      end
    end
  end

  private
    def asset_params
      params.require(:asset).permit(:filename, :title)
    end

    def log_update(asset)
      location = current_library
      location_url = library_url(current_library)

      AssetActivity.create({
        action: "updated_asset",
        user_id: current_user.id,
        user_email: current_user.email,
        activity_object_id: asset.id,
        object_text: asset.title,
        object_url: library_asset_url(current_library.id, asset.id),
        library_id: current_library.id,
        ip: request.remote_ip,
        location: "London,UK",
        browser: request.env["HTTP_USER_AGENT"]
      })
    end

    def log_delete(asset)
      location = current_library
      location_url = library_url(current_library)

      AssetActivity.create({
        action: "deleted_asset",
        user_id: current_user.id,
        user_email: current_user.email,
        activity_object_id: asset.id,
        object_text: asset.title,
        object_url: library_asset_url(current_library.id, asset.id),
        secondary_object_id: location.id,
        secondary_object_url: location_url,
        secondary_object_class: location.class.to_s,
        secondary_object_method: "name",
        secondary_object_text: location.name,
        library_id: current_library.id,
        ip: request.remote_ip,
        location: "London,UK",
        browser: request.env["HTTP_USER_AGENT"]
      })
    end
end
