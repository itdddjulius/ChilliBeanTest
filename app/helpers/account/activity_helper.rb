module Account::ActivityHelper
  def asset_text(activity)
    if Asset.exists? activity.activity_object_id
      asset = Asset.with_deleted.find activity.activity_object_id

      if asset.deleted?
        asset.title
      else
        link_to asset.title, library_asset_url(activity.library_id, asset)
      end
    else
      activity.object_text
    end
  end

  def library_text(activity)
    if Library.exists? activity.activity_object_id
      library = Library.find activity.activity_object_id
      link_to library.name, library_url(library.id)
    else
      activity.object_text
    end
  end

  def role_text(activity)
    if Role.exists? activity.activity_object_id
      role = Role.find activity.activity_object_id
      role.name
    else
      activity.object_text
    end
  end

  def collection_text(activity)
    if Collection.exists? activity.activity_object_id
      collection = Collection.find activity.activity_object_id
      link_to activity.object_text, library_collection_url(activity.library_id, collection.id)
    else
      activity.object_text
    end
  end

  def folder_text(activity)
    activity.object_text
  end

  def infofield_text(activity)
    if InfoField.exists? activity.activity_object_id
      field = InfoField.find activity.activity_object_id
      field.name
    else
      activity.object_text
    end
  end

  def secondary_object_text(activity)
    klass = activity.secondary_object_class.classify.constantize
    if klass.exists? activity.secondary_object_id
      secondary_object = klass.find activity.secondary_object_id

      if activity.secondary_object_url
        link_to secondary_object.send(activity.secondary_object_method), activity.secondary_object_url
      else
        secondary_object.send(activity.secondary_object_method)
      end
    else
      activity.secondary_object_text
    end
  end

  def activity_creator_text(activity)
    if activity.user_id.eql? current_user.id
      link_to "You", user_path(activity.user_id), class: "fancybox user-profile", "data-fancybox-type" => "ajax"
    else
      link_to activity.user_email, user_path(activity.user_id), class: "fancybox user-profile", "data-fancybox-type" => "ajax"
    end
  end

  def user_text(activity)
    if User.exists? activity.activity_object_id
      user = User.find activity.activity_object_id
      link_to user.fullname, user_path(user.id), class: "fancybox user-profile", "data-fancybox-type" => "ajax"
    else
      activity.object_text
    end
  end

  def info_field_changes(activity)
    ""
  end
end