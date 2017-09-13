module MediaHelper
  def branding_thumbnail(id = "account-branding-image", class_attr = "", dimensions = "300x80")
    image_tag(branding_image, :alt => "ChilliPharm", id: id, class: class_attr + " img-responsive", :height => dimensions.split("x").last)
  end

  def branding_image
    image_path "chillipharm-logo.jpg"
  end

  def avatar(class_str="", dimensions="40x40")
    image_tag("users/avatar-filler.jpg", height: dimensions.split("x").first, class: class_str, alt: "ChilliPharm User Avatar")
  end

  def avatar_image
    image_path("users/avatar-filler.jpg")
  end

  def asset_thumbnail(asset, dimensions="150x150", class_attr="")
    width = dimensions.split("x").first.to_i

    image_tag(asset_thumbnail_url(asset, dimensions), class: class_attr, width: width)
  end

  def asset_thumbnail_url(asset, dimensions="150x150")
    size = dimensions.split("x").first.to_i > 150 ? "large" : "medium"
    if asset.image?
      asset_url "asset-icons/#{size}/img.gif"
    elsif asset.video?
      asset_url "asset-icons/#{size}/video.gif"
    elsif asset.audio?
      asset_url "asset-icons/#{size}/audio.gif"
    elsif asset.document?
      asset_url "asset-icons/#{size}/doc.gif"
    else
      asset_url "asset-icons/#{size}/unknown.gif"
    end
  end

  def video_url(asset, transform="h2641P")
    nil
  end

  def video_tags(asset)
    inspector = MediaInspector.new(asset)
    "#{inspector.video_standard} #{inspector.definition} #{inspector.aspect_ratio}"
  end

  def in_admin_area?
    controller.class.name.downcase.include?("administration")
  end
end
