[![Build Status](https://secure.travis-ci.org/ileitch/rapns.png?branch=master)](http://travis-ci.org/ileitch/rapns)

### Rapns - Professional grade APNs and GCM daemon

* Supports both APNs (iOS) and GCM (Google Cloud Messaging, Android).
* Seamless Rails integration.
* Scalable - choose the number of threads each app spawns.
* Designed for uptime - signal -HUP to add, update apps.
* Stable - reconnects database and network connections when lost.
* Works with MRI, JRuby, Rubinius 1.8 and 1.9.
* [Airbrake](http://airbrakeapp.com/) integration.

#### 2.x users please read [upgrading from 2.x to 3.0](rapns/wiki/Upgrading-from-version-2.x-to-3.0)

### Who uses Rapns?

[GateGuru](http://gateguruapp.com) and [Desk.com](http://desk.com), among others!

*I'd love to hear if you use Rapns - @ileitch on twitter.*

## Getting Started

Add Rapns to your Gemfile:

    gem 'rapns'

Generate the migrations, rapns.yml and migrate:

    rails g rapns
    rake db:migrate

## Generating Certificates (APNs only)

1. Open up Keychain Access and select the `Certificates` category in the sidebar.
2. Expand the disclosure arrow next to the iOS Push Services certificate you want to export.
3. Select both the certificate and private key.
4. Right click and select `Export 2 items...`.
5. Save the file as `cert.p12`, make sure the File Format is `Personal Information Exchange (p12)`.
6. If you decide to set a password for your exported certificate, please read the 'Adding Apps' section below.
7. Convert the certificate to a .pem, where `<environment>` should be `development` or `production`, depending on the certificate you exported.

    `openssl pkcs12 -nodes -clcerts -in cert.p12 -out <environment>.pem`

## Create an App

#### APNs
```ruby
app = Rapns::Apns::App.new
app.name = "ios_app"
app.certificate = File.read("/path/to/development.pem")
app.environment = "development"
app.password = "certificate password"
app.connections = 1
app.save!
```

#### GCM
```ruby
app = Rapns::Gcm::App.new
app.name = "android_app"
app.auth_key = "..."
app.connections = 1
app.save!
```

## Create a Notification

#### APNs
```ruby
n = Rapns::Apns::Notification.new
n.app = Rapns::Apns::App.find_by_name("ios_app")
n.device_token = "..."
n.alert = "hi mom!"
n.attributes_for_device = {:foo => :bar}
n.save!
```

#### GCM
```ruby
n = Rapns::Gcm::Notification.new
n.app = Rapns::Gcm::App.find_by_name("android_app")
n.registration_ids = ["..."]
n.data = {:message => "hi mom!"}
n.save!

```

## Starting Rapns

    cd /path/to/rails/app
    rapns <Rails environment> [options]

See [Configuration](rapns/wiki/Configuration) for a list of options, or run `rapns --help`.

## Updating Rapns

After updating you should run `rails g rapns` to check for any new migrations.

## Consider using blpop

Rapns daemon will not need to poll and query undelivered notifications frequently, 
the notification will be enqueued immediately after being created successfully.   
to enable blpop:

    Rapns.configure do |config|
      config.blpop = true
      config.redis_backend = 'redis://127.0.0.1:6379/1'
    end


## Wiki

### General
* [Configuration](rapns/wiki/Configuration)
* [Upgrading from 2.x to 3.0](rapns/wiki/Upgrading-from-version-2.x-to-3.0)
* [Deploying to Heroku](rapns/wiki/Heroku)
* [Hot App Updates](rapns/wiki/Hot-App-Updates)

### APNs
* [Advanced APNs Features](rapns/wiki/Advanced-APNs-Features)
* [APNs Delivery Failure Handling](rapns/wiki/APNs-Delivery-Failure-Handling)
* [Why open multiple connections to the APNs?](rapns/wiki/Why-open-multiple-connections-to-the-APNs%3F)
* [Silent failures might be dropped connections](rapns/wiki/Dropped-connections)

### GCM

## Contributing

Fork as usual and go crazy!

When running specs, please note that the ActiveRecord adapter can be changed by setting the `ADAPTER` environment variable. For example: `ADAPTER=postgresql rake`.

Available adapters for testing are `mysql`, `mysql2` and `postgresql`.

Note that the database username is changed at runtime to be the currently logged in user's name. So if you're testing
with mysql and you're using a user named 'bob', you will need to grant a mysql user 'bob' access to the 'rapns_test'
mysql database.

### Contributors

Thank you to the following wonderful people for contributing:

* [@blakewatters](https://github.com/blakewatters)
* [@forresty](https://github.com/forresty)
* [@sjmadsen](https://github.com/sjmadsen)
* [@ivanyv](https://github.com/ivanyv)
* [@taybenlor](https://github.com/taybenlor)
* [@tompesman](https://github.com/tompesman)
* [@EpicDraws](https://github.com/EpicDraws)
* [@dei79](https://github.com/dei79)
* [@adorr](https://github.com/adorr)
* [@mattconnolly](https://github.com/mattconnolly)
* [@emeitch](https://github.com/emeitch)
