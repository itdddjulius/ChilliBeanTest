# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

# Don't seed data for production environment just now!

include Rails.application.routes.url_helpers

if Rails.env.eql?("development")
  # users
  user_one = User.create(name: "ChilliBean Administrator", email: "admin@chillipharm.com", password: "Testtest123", password_confirmation: "Testtest123", chillibean_staff: true, activated: true, password_reset_date: DateTime.now)
  user_two = User.create(name: "Joe Bloggs", email: "joe@chillipharm.com", password: "Testtest123", password_confirmation: "Testtest123", chillibean_staff: false, activated: true, password_reset_date: DateTime.now)
  user_three = User.create(name: "Wanda Bloggs", email: "wanda@chillipharm.com", password: "Testtest123", password_confirmation: "Testtest123", chillibean_staff: false, activated: true, password_reset_date: DateTime.now)

  # Libraries
  first_library = Library.create(name: "A Populated Library", creator: user_one)
  second_library = Library.create(name: "Other Library", creator: user_one)

  # Asset 1
  video_asset_one = Asset.create(filename: "trial 106.mov", title: "Trial 106", filesize: 100.megabytes, file_type: Asset.file_types[:video], uploader: user_two, library: first_library, created_at: 2.weeks.ago)

  AssetActivity.create({
    action: "uploaded_asset",
    user_id: user_two.id,
    user_email: user_two.email,
    activity_object_id: video_asset_one.id,
    object_text: video_asset_one.title,
    object_url: library_asset_url(video_asset_one.library.id, video_asset_one.id, host: "localhost:3000"),
    secondary_object_id: video_asset_one.library.id,
    secondary_object_url: library_url(video_asset_one.library.id, host: "localhost:3000"),
    secondary_object_class: video_asset_one.library.class.to_s,
    secondary_object_method: "name",
    secondary_object_text: video_asset_one.library.name,
    library_id: video_asset_one.library.id,
    ip: "192.168.0.17",
    location: "London,UK",
    browser: "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_6) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/59.0.3071.115 Safari/537.36",
  })

  comment = video_asset_one.comments.build(comment: "Evaluators comments", author: user_two)
  comment.save
  AssetActivity.create({
    action: "commented_on_asset",
    user_id: user_two.id,
    user_email: user_two.email,
    activity_object_id: video_asset_one.id,
    object_text: video_asset_one.title,
    object_url: library_asset_url(video_asset_one.library.id, video_asset_one.id, host: "localhost:3000"),
    secondary_object_id: comment.id,
    secondary_object_class: comment.class.to_s,
    secondary_object_method: "comment",
    secondary_object_text: comment.comment,
    library_id: video_asset_one.library.id,
    ip: "192.168.0.17",
    location: "London,UK",
    browser: "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_6) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/59.0.3071.115 Safari/537.36",
  })

  comment = video_asset_one.comments.build(comment: "Evaluators comments reply", author: user_three)
  comment.save
  AssetActivity.create({
    action: "commented_on_asset",
    user_id: user_three.id,
    user_email: user_three.email,
    activity_object_id: video_asset_one.id,
    object_text: video_asset_one.title,
    object_url: library_asset_url(video_asset_one.library.id, video_asset_one.id, host: "localhost:3000"),
    secondary_object_id: comment.id,
    secondary_object_class: comment.class.to_s,
    secondary_object_method: "comment",
    secondary_object_text: comment.comment,
    library_id: video_asset_one.library.id,
    ip: "192.168.0.16",
    location: "Bristol,UK",
    browser: "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_6) AppleWebKit/603.3.8 (KHTML, like Gecko) Version/10.1.2 Safari/603.3.8",
  })

  # Asset 2
  video_asset_two = Asset.create(filename: "trial 107.mov", title: "Trial 107", filesize: 100.megabytes, file_type: Asset.file_types[:video], uploader: user_two, library: first_library, created_at: 1.weeks.ago)

  AssetActivity.create({
    action: "uploaded_asset",
    user_id: user_two.id,
    user_email: user_two.email,
    activity_object_id: video_asset_two.id,
    object_text: video_asset_two.title,
    object_url: library_asset_url(video_asset_two.library.id, video_asset_two.id, host: "localhost:3000"),
    secondary_object_id: video_asset_two.library.id,
    secondary_object_url: library_url(video_asset_two.library.id, host: "localhost:3000"),
    secondary_object_class: video_asset_two.library.class.to_s,
    secondary_object_method: "name",
    secondary_object_text: video_asset_two.library.name,
    library_id: video_asset_two.library.id,
    ip: "192.168.0.17",
    location: "London,UK",
    browser: "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_6) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/59.0.3071.115 Safari/537.36",
  })

  comment = video_asset_two.comments.build(comment: "Evaluators comments", author: user_two)
  comment.save
  AssetActivity.create({
    action: "commented_on_asset",
    user_id: user_two.id,
    user_email: user_two.email,
    activity_object_id: video_asset_two.id,
    object_text: video_asset_two.title,
    object_url: library_asset_url(video_asset_two.library.id, video_asset_two.id, host: "localhost:3000"),
    secondary_object_id: comment.id,
    secondary_object_class: comment.class.to_s,
    secondary_object_method: "comment",
    secondary_object_text: comment.comment,
    library_id: video_asset_two.library.id,
    ip: "192.168.0.17",
    location: "London,UK",
    browser: "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_6) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/59.0.3071.115 Safari/537.36",
  })

  comment = video_asset_two.comments.build(comment: "Evaluators comments reply", author: user_three)
  comment.save
  AssetActivity.create({
    action: "commented_on_asset",
    user_id: user_three.id,
    user_email: user_three.email,
    activity_object_id: video_asset_two.id,
    object_text: video_asset_two.title,
    object_url: library_asset_url(video_asset_two.library.id, video_asset_two.id, host: "localhost:3000"),
    secondary_object_id: comment.id,
    secondary_object_class: comment.class.to_s,
    secondary_object_method: "comment",
    secondary_object_text: comment.comment,
    library_id: video_asset_two.library.id,
    ip: "192.168.0.16",
    location: "Bristol,UK",
    browser: "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_6) AppleWebKit/603.3.8 (KHTML, like Gecko) Version/10.1.2 Safari/603.3.8",
  })

  # Asset 3
  image_asset = Asset.create(filename: "image.jpg", title: "MRI 003", filesize: 2.megabytes, file_type: Asset.file_types[:image], uploader: user_two, library: first_library, created_at: 4.days.ago)

  AssetActivity.create({
    action: "uploaded_asset",
    user_id: user_two.id,
    user_email: user_two.email,
    activity_object_id: image_asset.id,
    object_text: image_asset.title,
    object_url: library_asset_url(image_asset.library.id, image_asset.id, host: "localhost:3000"),
    secondary_object_id: image_asset.library.id,
    secondary_object_url: library_url(image_asset.library.id, host: "localhost:3000"),
    secondary_object_class: image_asset.library.class.to_s,
    secondary_object_method: "name",
    secondary_object_text: image_asset.library.name,
    library_id: image_asset.library.id,
    ip: "192.168.0.17",
    location: "London,UK",
    browser: "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_6) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/59.0.3071.115 Safari/537.36",
  })

  # Asset 4
  audio_asset = Asset.create(filename: "audio file.mp3", title: "Audio Recording 1", filesize: 20.megabytes, file_type: Asset.file_types[:audio], uploader: user_two, library: first_library, created_at: 3.days.ago)

  AssetActivity.create({
    action: "uploaded_asset",
    user_id: user_two.id,
    user_email: user_two.email,
    activity_object_id: audio_asset.id,
    object_text: audio_asset.title,
    object_url: library_asset_url(audio_asset.library.id, audio_asset.id, host: "localhost:3000"),
    secondary_object_id: audio_asset.library.id,
    secondary_object_url: library_url(audio_asset.library.id, host: "localhost:3000"),
    secondary_object_class: audio_asset.library.class.to_s,
    secondary_object_method: "name",
    secondary_object_text: audio_asset.library.name,
    library_id: audio_asset.library.id,
    ip: "192.168.0.17",
    location: "London,UK",
    browser: "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_6) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/59.0.3071.115 Safari/537.36",
  })

  # Asset 5
  document_asset_one = Asset.create(filename: "patient A report.pdf", title: "Report of Patient A", filesize: 7.megabytes, file_type: Asset.file_types[:document], uploader: user_two, library: first_library, created_at: 2.days.ago)

  AssetActivity.create({
    action: "uploaded_asset",
    user_id: user_two.id,
    user_email: user_two.email,
    activity_object_id: document_asset_one.id,
    object_text: document_asset_one.title,
    object_url: library_asset_url(document_asset_one.library.id, document_asset_one.id, host: "localhost:3000"),
    secondary_object_id: document_asset_one.library.id,
    secondary_object_url: library_url(document_asset_one.library.id, host: "localhost:3000"),
    secondary_object_class: document_asset_one.library.class.to_s,
    secondary_object_method: "name",
    secondary_object_text: document_asset_one.library.name,
    library_id: document_asset_one.library.id,
    ip: "192.168.0.17",
    location: "London,UK",
    browser: "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_6) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/59.0.3071.115 Safari/537.36",
  })

  # Asset 6
  document_asset_two = Asset.create(filename: "patient B report.pdf", title: "Report of Patient B", filesize: 8.megabytes, file_type: Asset.file_types[:document], uploader: user_two, library: first_library, created_at: 1.day.ago)

  AssetActivity.create({
    action: "uploaded_asset",
    user_id: user_two.id,
    user_email: user_two.email,
    activity_object_id: document_asset_two.id,
    object_text: document_asset_two.title,
    object_url: library_asset_url(document_asset_two.library.id, document_asset_two.id, host: "localhost:3000"),
    secondary_object_id: document_asset_two.library.id,
    secondary_object_url: library_url(document_asset_two.library.id, host: "localhost:3000"),
    secondary_object_class: document_asset_two.library.class.to_s,
    secondary_object_method: "name",
    secondary_object_text: document_asset_two.library.name,
    library_id: document_asset_two.library.id,
    ip: "192.168.0.17",
    location: "London,UK",
    browser: "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_6) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/59.0.3071.115 Safari/537.36",
  })

  comment = document_asset_two.comments.build(comment: "Comment one", author: user_one)
  comment.save
  AssetActivity.create({
    action: "commented_on_asset",
    user_id: user_one.id,
    user_email: user_one.email,
    activity_object_id: document_asset_two.id,
    object_text: document_asset_two.title,
    object_url: library_asset_url(document_asset_two.library.id, document_asset_two.id, host: "localhost:3000"),
    secondary_object_id: comment.id,
    secondary_object_class: comment.class.to_s,
    secondary_object_method: "comment",
    secondary_object_text: comment.comment,
    library_id: document_asset_two.library.id,
    ip: "192.168.0.16",
    location: "Bristol,UK",
    browser: "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_6) AppleWebKit/603.3.8 (KHTML, like Gecko) Version/10.1.2 Safari/603.3.8",
  })

  # Asset 7
  unkown_asset = Asset.create(filename: "presentation.ppx", title: "ChilliPharm Presentation", filesize: 5.megabytes, file_type: Asset.file_types[:unknown], uploader: user_two, library: first_library, created_at: 5.weeks.ago)

  AssetActivity.create({
    action: "uploaded_asset",
    user_id: user_two.id,
    user_email: user_two.email,
    activity_object_id: unkown_asset.id,
    object_text: unkown_asset.title,
    object_url: library_asset_url(unkown_asset.library.id, unkown_asset.id, host: "localhost:3000"),
    secondary_object_id: unkown_asset.library.id,
    secondary_object_url: library_url(unkown_asset.library.id, host: "localhost:3000"),
    secondary_object_class: unkown_asset.library.class.to_s,
    secondary_object_method: "name",
    secondary_object_text: unkown_asset.library.name,
    library_id: unkown_asset.library.id,
    ip: "192.168.0.17",
    location: "London,UK",
    browser: "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_6) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/59.0.3071.115 Safari/537.36",
  })

  # Asset 8
  video_asset_three = Asset.create(filename: "trial 109.mov", title: "Trial 109", filesize: 107.megabytes, file_type: Asset.file_types[:video], uploader: user_two, library: second_library, created_at: 1.weeks.ago)

  AssetActivity.create({
    action: "uploaded_asset",
    user_id: user_two.id,
    user_email: user_two.email,
    activity_object_id: video_asset_three.id,
    object_text: video_asset_three.title,
    object_url: library_asset_url(video_asset_three.library.id, video_asset_three.id, host: "localhost:3000"),
    secondary_object_id: video_asset_three.library.id,
    secondary_object_url: library_url(video_asset_three.library.id, host: "localhost:3000"),
    secondary_object_class: video_asset_three.library.class.to_s,
    secondary_object_method: "name",
    secondary_object_text: video_asset_three.library.name,
    library_id: video_asset_three.library.id,
    ip: "192.168.0.17",
    location: "London,UK",
    browser: "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_6) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/59.0.3071.115 Safari/537.36",
  })
end
