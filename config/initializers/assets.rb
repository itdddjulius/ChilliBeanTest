# Be sure to restart your server when you modify this file.
# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '1.0'
# Add additional assets to the asset load path
# Rails.application.config.assets.paths << Emoji.images_path
# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in app/assets folder are already added.
Rails.application.config.assets.precompile += %w( marketing.css marketing.js libs/modernizr-2.8.3-respond-1.4.2.min.js manage.css manage.js uploader.js libs/colorwheel.js libs/html5shiv.js uploader.css uploading.js libs/aspera/connectinstaller-4.min.js libs/aspera/asperaweb-4.min.js libs/aspera/initialize_aspera.js libs/underscore-1.4.4.js jquery.js jquery-ui.js libs/blueimp/jquery.fileupload.min.js cookieconsent.min.css libs/cookieconsent.min.js libs/scrollreveal.min.js )
