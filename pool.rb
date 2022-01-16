require 'rubygems'
require 'date'
require 'selenium-webdriver'
include Selenium::WebDriver::Support

def schwimhalle_url
  # BAD URL - example: "https://pretix.eu/Baeder/<CODE>/?voucher=URBANSPORTSCLUB"
  return "URL_HERE"
end

def find_date_retry(time, driver, current_try)
  current_try += 1
  max_retry = 60
  begin
    if current_try >= max_retry
      return
    end
    unless current_try == 0
      driver.navigate.refresh
      driver.navigate.to schwimhalle_url
    end
    # Find time
    selector = "[data-date=\"#{Date.today + 4}\"] [datetime=\"#{time}\"]"
    element = driver.find_element(css: selector)
    driver.action.move_to(element).perform
    element.click
    not_start_msg = "The presale period for this event has not yet started."
    error_msg = "Error:"

    # add to cart
    element = driver.find_element(id: "btn-add-to-cart")
    element.click
    sleep(3)
    element = driver.find_element(css: "div#error-message")
    if element.text.include? not_start_msg
      find_date_retry(time, driver, current_try)
    end
  rescue => e
    # retry
    puts("\n\n\n#{e}\n\n\n")
    sleep(5)
    find_date_retry(time, driver, current_try)
  end
end

def run
  options = Selenium::WebDriver::Chrome::Options.new
  options.add_argument('--headless')

  driver = Selenium::WebDriver.for :chrome, options: options
  driver.navigate.to schwimhalle_url

  # Click to log in
  element = driver.find_element(:class, "loginstatus")
  element.click

  # Log in
  element = driver.find_element(:name, "email")
  element.send_keys "USERNAME"
  element = driver.find_element(:name, "password")
  element.send_keys "PASSWORD"
  element.submit

  find_date_retry("#{ARGV[0]}", driver, 0)

  sleep(5)
  # continue
  element = driver.find_element(class: "checkout-button-primary")
  element.submit
  # continue
  element = driver.find_element(css: "button.btn.btn-block.btn-primary.btn-lg")
  element.submit

  # fill form
  element = driver.find_element(css: "button.profile-apply.btn.btn-default")
  element.click
  # continue
  element = driver.find_element(css: "button.btn.btn-block.btn-primary.btn-lg")
  element.submit

  # confirm vaccine
  element = driver.find_element(css: "input#input_confirm_confirm_text_0")
  element.click
  # submit ticket
  element = driver.find_element(css: "button.btn.btn-block.btn-primary.btn-lg")
  element.submit

  sleep(10)
  driver.quit 
end

run