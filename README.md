# Berliner baeder - automatic purchase

This is a project created for studing purposes only and should not be used in production.

## Instalation

1. Update ruby version (I run using `3.0`)
2. Install selenium web driver gem: `$ gem install selenium-webdriver`
3. Install chrome driver: `$ brew install --cask chromedriver`

## Running bot

### Update parameters

After cloning the repo you need to replace `USERNAME` and `PASSWORD`

Also, replace the `URL_HERE` with the pool you want to buy the tickets

### Purchasing

To run the bot, you need to specify which starting time of the session it should look for. For example:
If session goes from `11:00-13:00` you need to specify `11:00`

Just run the command: `$ ruby pool.rb "11:00"`

NOTE: the bot always buy 4 days in advance, so you can buy as soon as it opens