class MediaInspector
  attr_accessor :asset, :extension

  def initialize(asset=nil, filename=nil)
    if asset.present?
      @asset = asset
      @extension = File.extname(asset.filename).gsub(".","").downcase
      @mime_type = asset.mime_type
    elsif filename.present?
      @asset = nil
      @mime_type = nil
      @extension = File.extname(filename).gsub(".","").downcase
    end
  end

  def media_info
    @asset.media_info if @asset
  end

  def media_type
    if video?
      :video
    elsif audio?
      :audio
    elsif image?
      :image
    elsif document?
      :document
    else
      :unknown
    end
  end

  def document?
    return false if @extension.empty?

    [ :pdf,
      :doc,
      :docx,
      :xls,
      :xlsx,
      :ppt,
      :pptx,
      :txt,
      :pages,
      :odt,
      :rtf
    ].include?(@extension.to_sym)
  end

  def image?
    return false if @extension.empty?

    [ :ai,
      :bmp,
      :eps,
      :gif,
      :gif87,
      :ico,
      :j2c,
      :jp2,
      :jpeg,
      :jpg,
      :pbm,
      :pcd,
      :pct,
      :pcx,
      :pict,
      :pjpeg,
      :png,
      :png24,
      :png32,
      :png8,
      :pnm,
      :ppm,
      :ps,
      :psd,
      :ras,
      :tga,
      :tif,
      :tiff,
      :wbmp,
      :xbm,
      :xpm,
      :xwd
    ].include?(@extension.to_sym)

  end

  def video?
    return false if @extension.empty?

    if @mime_type.eql?("application/octet-stream") || @mime_type.nil?
      [ "mts",
        "avi",
        "dv",
        "mov",
        "mpg",
        "mpeg",
        "m2v",
        "m2p",
        "wmv",
        "mp4",
        "3gp",
        "mpg",
        "omf",
        "mod",
        "wmv",
        "divx",
        "mp4",
        "mpa",
        "mxf",
        "R3D",
        "mpg1",
        "sfv",
        "mkv",
        "m4v",
        "qt",
        "flv",
        "f4v",
        "webm",
        "ogv",
        "vob"
      ].include?(@extension)
    else
      [
        'application/x-mp4',
        'video/mpeg',
        'video/quicktime',
        'video/x-la-asf',
        'video/x-ms-asf',
        'video/x-msvideo',
        'video/x-sgi-movie',
        'video/x-flv',
        'flv-application/octet-stream',
        'video/3gpp',
        'video/3gpp2',
        'video/3gpp-tt',
        'video/BMPEG',
        'video/BT656',
        'video/CelB',
        'video/DV',
        'video/H261',
        'video/H263',
        'video/H263-1998',
        'video/H263-2000',
        'video/H264',
        'video/JPEG',
        'video/MJ2',
        'video/MP1S',
        'video/MP2P',
        'video/MP2T',
        'video/mp4',
        'video/MP4V-ES',
        'video/MPV',
        'video/mpeg4',
        'video/mpeg4-generic',
        'video/nv',
        'video/parityfec',
        'video/pointer',
        'video/raw',
        'video/rtx'
      ].collect { |mime| mime.downcase }.include?(@mime_type.downcase)
    end
  end

  def document?
    return false if @extension.empty?

    [ :pdf,
      :doc,
      :docx,
      :xls,
      :xlsx,
      :ppt,
      :pptx,
      :txt,
      :pages,
      :odt,
      :rtf
    ].include?(@extension.to_sym)
  end

  def audio?
    return false if @extension.empty?

    [ :mp3,
      :wav,
      :aif,
      :aiff,
      :ogg,
      :flac,
      :wma
    ].include?(@extension.to_sym)
  end

  def format
    if media_info["general"] && media_info["general"]["format"]
      media_info["general"]["format"]
    end
  end

  def width
    if video?
      if media_info["video"] && media_info["video"]["width"]
        media_info["video"]["width"].gsub("pixels", "").gsub(" ", "").to_i
      elsif media_info["video #1"] && media_info["video #1"]["width"]
        media_info["video #1"]["width"].gsub("pixels", "").gsub(" ", "").to_i
      else
        0
      end
    elsif image?
      if media_info["image"] && media_info["image"]["width"]
        media_info["image"]["width"].gsub("pixels", "").gsub(" ", "").to_i
      else
        0
      end
    end
  end

  def height
    if video?
      if media_info["video"] && media_info["video"]["height"]
        media_info["video"]["height"].gsub("pixels", "").gsub(" ", "").to_i
      elsif media_info["video #1"] && media_info["video #1"]["height"]
        media_info["video #1"]["height"].gsub("pixels", "").gsub(" ", "").to_i
      else
        0
      end
    elsif image?
      if media_info["image"] && media_info["image"]["height"]
        media_info["image"]["height"].gsub("pixels", "").gsub(" ", "").to_i
      else
        0
      end
    end
  end

  def high_definition?
    self.definition.eql?("HD")
  end

  def definition
    if video?
      definition = "SD"
      height = self.height
      width = self.width
      definition = "HD" if (width > 1800) || (width > 1100)

      definition
    end
  end

  def aspect_ratio
    aspect_ratio = ""

    return "" if !(media_info["video"] && media_info["video"]["display_aspect_ratio"]) || !(media_info["video #1"] && media_info["video #1"]["display_aspect_ratio"])

    if !media_info["video"]["display_aspect_ratio"].match(/:/).nil?
      aspect_ratio = media_info["video"]["display_aspect_ratio"]
      if !aspect_ratio.eql?("16:9") && !aspect_ratio.eql?("4:3")
        numerical_ratio = width.to_f / height.to_f
        if numerical_ratio < 1.56
          aspect_ratio = "4:3"
        else
          aspect_ratio = "16:9"
        end
      end
    elsif !media_info["video"]["display_aspect_ratio"].match(/\./).nil?
      num_value = media_info["video"]["display_aspect_ratio"].to_f
      if num_value < 1.56
        aspect_ratio = "4:3"
      else
        aspect_ratio = "16:9"
      end
    elsif !media_info["video #1"]["display_aspect_ratio"].match(/:/).nil?
      aspect_ratio = media_info["video #1"]["display_aspect_ratio"]
      if !aspect_ratio.eql?("16:9") && !aspect_ratio.eql?("4:3")
        numerical_ratio = width.to_f / height.to_f
        if numerical_ratio < 1.56
          aspect_ratio = "4:3"
        else
          aspect_ratio = "16:9"
        end
      end
    elsif !media_info["video #1"]["display_aspect_ratio"].match(/\./).nil?
      num_value = media_info["video #1"]["display_aspect_ratio"].to_f
      if num_value < 1.56
        aspect_ratio = "4:3"
      else
        aspect_ratio = "16:9"
      end
    else
      aspect_ratio = ""
    end

    aspect_ratio
  end

  def video_standard
    return "" unless media_info["video"] || media_info["video #1"]

    standard = ""

    if media_info["video"] && media_info["video"]["standard"]
      if media_info["video"]["standard"].downcase.eql?("component")
        framerate = 0
        if media_info["video"]["frame_rate"]
          framerate = media_info["video"]["frame_rate"].sub(" fps", "").to_f
        elsif media_info["video"]["nominal_frame_rate"]
          framerate = media_info["video"]["nominal_frame_rate"].sub(" fps", "").to_f
        end

        if framerate >= 29.97 && framerate <= 30
          standard = "NTSC"
        elsif framerate >= 23.5 && framerate <= 24.5
          standard = "FILM"
        else
          standard = "PAL"
        end
      else
        if @asset
          standard = @asset.asset.media_info["video"]["standard"]
        else
          standard = ""
        end
      end
    elsif media_info["video"] && (media_info["video"]["frame_rate"] || media_info["video"]["nominal_frame_rate"])
      framerate = 0
        if media_info["video"]["frame_rate"]
          framerate = media_info["video"]["frame_rate"].sub(" fps", "").to_f
        elsif media_info["video"]["nominal_frame_rate"]
          framerate = media_info["video"]["nominal_frame_rate"].sub(" fps", "").to_f
        end
      if framerate >= 29.97 && framerate <= 30
        standard = "NTSC"
      elsif framerate >= 23.5 && framerate <= 24.5
        standard = "FILM"
      else
        standard = "PAL"
      end
    elsif media_info["video #1"] && media_info["video #1"]["standard"]
      if media_info["video #1"]["standard"].downcase.eql?("component")
        framerate = 0
        if media_info["video #1"]["frame_rate"]
          framerate = media_info["video #1"]["frame_rate"].sub(" fps", "").to_f
        elsif media_info["video #1"]["nominal_frame_rate"]
          framerate = media_info["video #1"]["nominal_frame_rate"].sub(" fps", "").to_f
        end

        if framerate >= 29.97 && framerate <= 30
          standard = "NTSC"
        elsif framerate >= 23.5 && framerate <= 24.5
          standard = "FILM"
        else
          standard = "PAL"
        end
      else
        if @asset
          standard = @asset.asset.media_info["video #1"]["standard"]
        else
          standard = ""
        end
      end
    elsif media_info["video #1"] && (media_info["video #1"]["frame_rate"] || media_info["video #1"]["nominal_frame_rate"])
      framerate = 0
        if media_info["video #1"]["frame_rate"]
          framerate = media_info["video #1"]["frame_rate"].sub(" fps", "").to_f
        elsif media_info["video #1"]["nominal_frame_rate"]
          framerate = media_info["video #1"]["nominal_frame_rate"].sub(" fps", "").to_f
        end
      if framerate >= 29.97 && framerate <= 30
        standard = "NTSC"
      elsif framerate >= 23.5 && framerate <= 24.5
        standard = "FILM"
      else
        standard = "PAL"
      end
    end

    standard
  end

  def video_channel_format
    if video?
      format = ""
      if media_info["video"] && media_info["video"]["format"]
        format = media_info["video"]["format"]
      elsif media_info["video #1"] && media_info["video #1"]["format"]
        format = media_info["video #1"]["format"]
      end

      format
    end
  end

  def video_channel_framerate
    if video?
      framerate = 0
      if media_info["video"] && media_info["video"]["frame_rate"]
        framerate = media_info["video"]["frame_rate"].sub(" fps", "").to_f
      elsif media_info["video"] && media_info["video"]["nominal_frame_rate"]
        framerate = media_info["video"]["nominal_frame_rate"].sub(" fps", "").to_f
      elsif media_info["video #1"] && media_info["video #1"]["frame_rate"]
        framerate = media_info["video #1"]["frame_rate"].sub(" fps", "").to_f
      elsif media_info["video #1"] && media_info["video #1"]["nominal_frame_rate"]
        framerate = media_info["video #1"]["nominal_frame_rate"].sub(" fps", "").to_f
      end

      framerate
    end
  end

  def video_channel_framerate_mode
    if video?
      framerate_mode = ""
      if media_info["video"] && media_info["video"]["frame_rate_mode"]
        framerate_mode = media_info["video"]["frame_rate_mode"]
      elsif media_info["video #1"] && media_info["video #1"]["frame_rate_mode"]
        framerate_mode = media_info["video #1"]["frame_rate_mode"]
      end

      framerate_mode
    end
  end

  def video_channel_codec
    if video?
      codec = ""
      if media_info["video"] && media_info["video"]["codec_id"]
        codec = media_info["video"]["codec_id"]
      elsif media_info["video #1"] && media_info["video #1"]["codec_id"]
        codec = media_info["video #1"]["codec_id"]
      end

      codec
    end
  end

  def video_channel_codec_info
    if video?
      codec = ""
      if media_info["video"] && media_info["video"]["codec_id_info"]
        codec = media_info["video"]["codec_id_info"]
      elsif media_info["video #1"] && media_info["video #1"]["codec_id_info"]
        codec = media_info["video #1"]["codec_id_info"]
      end

      codec
    end
  end

  def video_channel_bit_rate
    if video?
      bit_rate = ""
      if media_info["video"] && media_info["video"]["bit_rate"]
        bit_rate = media_info["video"]["bit_rate"]
      elsif media_info["video #1"] && media_info["video #1"]["bit_rate"]
        bit_rate = media_info["video #1"]["bit_rate"]
      end

      normalize_bitrate(bit_rate)
    end
  end

  def video_channel_bit_rate_mode
    if video?
      mode = ""
      if media_info["video"] && media_info["video"]["bit_rate_mode"]
        mode = media_info["video"]["bit_rate_mode"]
      elsif media_info["video #1"] && media_info["video #1"]["bit_rate_mode"]
        mode = media_info["video #1"]["bit_rate_mode"]
      end

      mode
    end
  end

  def audio_channel_format
    if video? || audio?
      format = ""
      if media_info["audio"] && media_info["audio"]["format"]
        format = media_info["audio"]["format"]
      elsif media_info["audio #1"] && media_info["audio #1"]["format"]
        format = media_info["audio #1"]["format"]
      end

      format
    end
  end

  def audio_channel_codec
    if video?
      codec = ""
      if media_info["audio"] && media_info["audio"]["codec_id"]
        codec = media_info["audio"]["codec_id"]
      elsif media_info["audio #1"] && media_info["audio #1"]["codec_id"]
        codec = media_info["audio #1"]["codec_id"]
      end

      codec
    end
  end

  def audio_channel_codec_info
    if video?
      codec = ""
      if media_info["audio"] && media_info["audio"]["codec_id_info"]
        codec = media_info["audio"]["codec_id_info"]
      elsif media_info["audio #1"] && media_info["audio #1"]["codec_id_info"]
        codec = media_info["audio #1"]["codec_id_info"]
      end

      codec
    end
  end

  def audio_channel_bit_rate
    if video? || audio?
      bit_rate = ""
      if media_info["audio"] && media_info["audio"]["bit_rate"]
        bit_rate = media_info["audio"]["bit_rate"]
      elsif media_info["audio #1"] && media_info["audio #1"]["bit_rate"]
        bit_rate = media_info["audio #1"]["bit_rate"]
      end

      normalize_bitrate(bit_rate)
    end
  end

  def audio_channel_bit_rate_mode
    if video? || audio?
      mode = ""
      if media_info["audio"] && media_info["audio"]["bit_rate_mode"]
        mode = media_info["audio"]["bit_rate_mode"]
      elsif media_info["audio #1"] && media_info["audio #1"]["bit_rate_mode"]
        mode = media_info["audio #1"]["bit_rate_mode"]
      end

      mode
    end
  end

  def audio_channels
    if video? || audio?
      channels = ""
      if media_info["audio"] && media_info["audio"]["channels"]
        channels = media_info["audio"]["channels"].sub(" channels", "").to_i
      elsif media_info["audio #1"] && media_info["audio #1"]["channels"]
        channels = media_info["audio #1"]["channels"].sub(" channels", "").to_i
      end

      channels
    end
  end

  def duration
    if video? || audio?
      if media_info["general"] && media_info["general"]["duration"]
        duration_in_milliseconds(media_info["general"]["duration"])
      end
    end
  end

  def duration_in_milliseconds(duration_string)
    return 0 if !video? && !audio?

    millisecond_indicators = ["ms"]
    second_indicators = ["s"]
    minute_indicators = ["mn"]
    hour_indicators = ["h"]
    unit_separator = " "
    total_milliseconds = 0

    units = duration_string.split(unit_separator)
    units.each do |unit|
      int_value = 0

      if is_time_unit(unit, millisecond_indicators)
        int_value = time_string_to_int(unit, millisecond_indicators)
      elsif is_time_unit(unit, second_indicators)
        int_value = time_string_to_int(unit, second_indicators)
        int_value = int_value * 1000
      elsif is_time_unit(unit, minute_indicators)
        int_value = time_string_to_int(unit, minute_indicators)
        int_value = int_value * 60 * 1000
      elsif is_time_unit(unit, hour_indicators)
        int_value = time_string_to_int(unit, hour_indicators)
        int_value = int_value * 60 * 60 * 1000
      else
        # there was an unrecognised value in the string
        return 0
      end
      
      total_milliseconds = total_milliseconds + int_value
    end

    total_milliseconds
  end

  def is_time_unit(value, unit_type_indicators)
    unit_type_indicators.each do |indicator|
      return true if value.include?(indicator)
    end

    return false
  end

  def time_string_to_int(string_value, unit_indicators)
    int_value = 0
    unit_indicators.each do |indicator|
      int_value = string_value.gsub(indicator, "").to_i
    end

    int_value
  end

  # Converts bitrate into a float in Kbps
  def normalize_bitrate(bitrate_string)
    bitrate = 0
    if bitrate_string =~ / bps|bit\/sec/
      bitrate = bitrate_string.sub(" bps", "").sub("bit/sec", "").to_f
      bitrate = bitrate / 1000
    elsif bitrate_string =~ / Kbps/
      bitrate = bitrate_string.sub(" Kbps", "").to_f
    elsif bitrate_string =~ / Mbps/
      bitrate = bitrate_string.sub(" Mbps", "").to_f
      bitrate = bitrate * 1000
    elsif bitrate_string =~ / Gbps/
      bitrate = bitrate_string.sub(" Gbps", "").to_f
      bitrate = bitrate * 1000000
    end

    bitrate
  end
end
