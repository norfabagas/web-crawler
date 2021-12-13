## Web Crawler
#### Use this project
* Make sure you have installed Ruby (version 3) and bundler (`gem install bundler`) on your local environment
* Make sure to install libsqlite3-dev (it is required to use SQLite3 with Ruby)
* Install required packages (`bundle install`)

#### Run this project
* To start crawling website products, run `rake run`
* All data will be stored to SQLite database. To view all stored data run `rake result`