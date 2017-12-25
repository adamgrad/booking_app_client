# Client Application for mini BookingSync API

## Setup
These instruction will get you a copy of the project up and running on your local machine.

```
$ cd ~/workspace
$ git clone https://github.com/adamgrad/booking_app_client.git
$ cd booking_app_client
$ bundle install
```
### Important config
Make sure to rename config file
```
$ mv config/application.yml.example config/application.yml
```
In `application.yml`  *HOST* is set to http://localhost:3000 by default. If you are using different address for the server make sure to apply changes to this file.

After all those steps your test suite should pass
```
$ bin/rspec
```
