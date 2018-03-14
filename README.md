# Initial Setup

Ruby version: `2.4.3`

Install gems and prepare local database
```
bundle install
rails db:create db:migrate
```

# Secrets

This application uses [Figaro](https://github.com/laserlemon/figaro) to manage secrets.
Following commands create `config/application.yml` and adds to `.gitignore`
```
bundle binstubs figaro
figaro install
```

Inside `config/application.yml`
```
SPACE_ID: (space id goes here)
CONTENT_DELIVERY_API_TOKEN: (api token goes here)
```

# Start the application
```
rails s
```

# Endpoints

1. [All entries](http://localhost:3000/missions)
2. [Incremental Sync](http://localhost:3000/missions/sync)
3. [Reset](http://localhost:3000/missions/reset)
