module Account::LibrariesHelper
  def current_filter_label(filter)
    case filter
    when "video"
      "Video Only"
    when "audio"
      "Audio Only"
    when "image"
      "Image Only"
    else
      "All File Types"
    end
  end

  def current_sort_label(sort)
    case sort
    when "created_at_asc"
      "Oldest"
    when "created_at_desc"
      "Most Recent"
    when "title_asc"
      "Title A-Z"
    when "title_desc"
      "Title Z-A"
    else
      "Most Recent"
    end
  end

  def view_type_toggle(display_type, filter, sort, search, section, library, object=nil)
    args = {}
    args[:display] = display_type

    if filter.present?
      args[:filter] = filter
    end

    if sort.present?
      args[:sort] = sort
    end

    if search.present?
      args[:search] = search
    end

    icon = nil
    link_classes = []

    if display_type.eql?("list")
      icon = content_tag(:i, "", class: "fa fa-align-justify")
      link_classes << "list"
    else
      icon = content_tag(:i, "", class: "fa fa-th-large")
      link_classes << "grid"
    end

    if (view_option.eql?("list") && display_type.eql?("list")) || (view_option.eql?("grid") && display_type.eql?("grid"))
      link_classes << "active"
    end

    link_to icon, section_link(library, section, args, object), class: link_classes, "data-toggle" => "tooltip", title: "", "data-original-title" => "#{display_type.capitalize} View"
  end

  def filter_link(filter, sort, search, section, library, object=nil)
    args = {}
    args[:filter] = filter

    if sort.present?
      args[:sort] = sort
    end

    if search.present?
      args[:search] = search
    end

    section_link(library, section, args, object)
  end

  def sort_link(sort, filter, search, section, library, object=nil)
    args = {}
    args[:sort] = sort

    if filter.present?
      args[:filter] = filter
    end

    if search.present?
      args[:search] = search
    end

    section_link(library, section, args, object)
  end

  def section_link(library, section, args, object=nil)
    case section
    when "library"
      library_path(library, args)
    when "collection"
      library_collection_path(library, object, args)
    else
      library_path(library, args)
    end
  end
end
