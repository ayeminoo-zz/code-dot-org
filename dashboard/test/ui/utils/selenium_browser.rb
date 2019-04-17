require 'selenium/webdriver'
require 'webdrivers'

module SeleniumBrowser
  def self.local_browser(headless=true, browser=:chrome)
    browser = browser.to_sym
    options = {}
    if browser == :chrome
      options[:options] = Selenium::WebDriver::Chrome::Options.new
      if headless
        options[:options].add_argument('headless')
        options[:options].add_argument('window-size=1280,1024')
      end
    elsif browser == :firefox
      options[:options] = Selenium::WebDriver::Firefox::Options.new
      options[:options].headless! if headless
      options[:options].add_argument('window-size=1280,1024')
    end
    browser = Selenium::WebDriver.for browser, options
    if ENV['MAXIMIZE_LOCAL']
      max_width, max_height = browser.execute_script('return [window.screen.availWidth, window.screen.availHeight];')
      browser.manage.window.resize_to(max_width, max_height)
    end

    # Time to wait for any page loading to complete (default 5 minutes).
    browser.manage.timeouts.page_load = 2.minutes

    # Time to wait for any async script to timeout (default 30 seconds).
    browser.manage.timeouts.script_timeout = 90.seconds

    browser
  end
end
