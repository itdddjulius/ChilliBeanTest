# ChilliPharm Basic

A basic sandbox application with Libraries and Assets.

## Setup

Ruby 2.3.x is required for this application.

PostgreSQL is the database of choice. Make sure PostgreSQL is installed and running on your system (using something like Homebrew).

Create a `chillipharmbasic` role in PostgreSQL.  In the terminal while PostgreSQL is running:

```
createuser -s -r chillipharmbasic
```

Set up the database and seed data.  In the project directory run:

`rake db:setup`

Install gems.  In the project directory run:

`bundle install`

## Running in Development

Run using the Rails development server:

`rails s`

The app should now be running at: http://localhost:3000

## Running Test Suite

Run all normal tests:

`rspec`

Run all Selenium tests:

`rspec --tag js`

To run selenium tests you will need the latest Firefox and have installed, configured and have running geckodriver.  See here for more info:

https://developer.mozilla.org/en-US/docs/Mozilla/QA/Marionette/WebDriver#Downloading

## Restarting with the original Seed Data:

Wipe the database:

`rake db:drop`

Recreate:

`rake db:setup`

## Julius Olatokunbo- Modifications
As per ChilliBean Test - (libraries_controller.rb)

    if params[:filter] && params[:filter].eql?("video")
      @assets = Asset.where(file_type: 0)
    end
    if params[:filter] && params[:filter].eql?("image")
      @assets = Asset.where(file_type: 1)
    end
    if params[:filter] && params[:filter].eql?("audio")
      @assets = Asset.where(file_type: 2)
    end
============================================================


