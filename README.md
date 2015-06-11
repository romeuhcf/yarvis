# YARVIS
*(samos nozes)*


## Yet Another ReVolutionary Integration System ##


### Installing ###
If you got Unsupported URL error with any SSH git repository, make sure you installed rugged gem with all 
system dependencies and compilation headers previously installed. (openssh-dev, libssl-dev).

To run the system you'll need to: 
* clone the repo
* install necessary ruby version ( > 2.0)
* install necessary system dependencies - check dependencies for rugged gen
* install the gems with `bundle install`
* prepare the database with rake db:create db:migrate
* start server with rails s (or any infrastructure you prefer)
* start sidekiq workers with `sidekiq`

For a single node setup you'll need the docker system running a a user with docker permissions

### TODO ###

High prio
* Container disposal - removal
* Services linking
* Adding to SSH Known Hosts # http://docs.travis-ci.com/user/ssh-known-hosts/
* Cacheable directories
* External hooks
* RVM not switching rubies correctly

Medium prio
* Remote docker server access and management
* Job path stick into the docker server - schedule each derived sidekiq worker on to the same worker server queue

Low prio
* Allow job failures inside the matrix pipeline
* Branch build
* Branch blacklist/whitelist




