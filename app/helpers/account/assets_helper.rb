module Account::AssetsHelper
  def info_field_form(asset, info_fields, info_values)
    return "" if info_fields.empty?

    html = asset_info_field_form(library_asset_path(current_library, asset), info_fields, info_values)

    html.html_safe
  end

  def mandatory_info_field(info_field)
    if info_field.name.downcase.eql?('title') || info_field.required
      return 'mandatory'
    end
  end

  def asset_active_tab(action)
    "active" if controller.action_name.eql?(action) || controller.controller_name.eql?(action)
  end

  def transcode_name_text(transcode)
    case transcode
    when "h2641P"
      "H264 Web Proxy"
    else
      transcode
    end
  end

  def asset_file_type_icon(asset)
    if asset.file_type
      asset.file_type
    else
      "unknown"
    end
  end

  def metadata_list_tag(metadata)
    html = ""
    return "" if metadata.empty?
    metadata.each do |key, val|
      if val.class.to_s.downcase.eql?("hash")
        html << content_tag(:h2, "#{key.capitalize} Metadata")
        html << content_tag(:dl, class: "dl-horizontal") {
          nested_html = metadata_list_tag(val)
          nested_html.html_safe
        }
      else
        unless key.eql?("complete_name")
          html << content_tag(:dt, key)
          html << content_tag(:dd, val)
        end
      end
    end

    html.html_safe
  end

  def list_view_video_status(asset)
    if asset.video? && !has_transform(asset)
      "pending-badge-small"
    end 
  end

  def has_transform(asset, transform="h2641P")
    false
  end

  private
    def asset_info_field_form(url, info_fields, info_values)
      form = ""

      html = form_tag url, method: :patch, id: "info-field-form" do
        info_fields.each do |field|
          info_value = info_values.detect { |info_value| info_value.info_field_id.eql?(field.id) }
          value = info_value.nil? ? "" : info_value.value
          form += "<div class='form-group'>"
          form += label_tag field.id, field.name, class: "control-label"


          if field.field_type.eql?("string")
            form += text_field_tag "asset[asset_infos_attributes][][value]", value, class: "form-control", id: field.id
          elsif field.field_type.eql?("text")
            form += text_area_tag "asset[asset_infos_attributes][][value]", value, class: "form-control", rows: "3", id: field.id
          end
          form += hidden_field_tag "asset[asset_infos_attributes][][info_field_id]", field.id
          form += hidden_field_tag "asset[asset_infos_attributes][][id]", info_value.id if info_value

          form += "</div>"
        end

        form += submit_tag "Submit", class: "button"

        form.html_safe
      end

      html
    end
end
