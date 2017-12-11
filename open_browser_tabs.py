#!/usr/bin/env python2

import sys
import logging
from selenium import webdriver
from selenium.webdriver.common.keys import Keys

def load_urls(urls_path):
  with open(urls_path) as f:
    urls = f.readlines()
    urls = [x.strip().replace('\n', '') for x in urls]
  return urls

def get_chrome_options():
  chrome_options = webdriver.ChromeOptions()
  chrome_options.add_argument("--incognito")
  return chrome_options

def get_global_driver():
  # 1) Make sure Chromium is installed:
  #    `sudo apt-get install chromium`
  # 2) Install the right version of the Chrome Driver:
  # 2.1) for version 2.32
  #      `sudo apt-get install chromedriver` 
  #      (for Chromium versions approx below 59)
  # 2.2) for version 2.33:
  #      `wget https://chromedriver.storage.googleapis.com/2.33/chromedriver_linux64.zip`
  #      `sudo unzip -d /usr/local/bin/ chromedriver_linux64.zip`
  global_driver = webdriver.Chrome(chrome_options=get_chrome_options())
  global_driver.set_window_size(1366, 768)
  global_driver.implicitly_wait(5) # seconds
  global_driver.set_page_load_timeout(60)
  global_driver.set_script_timeout(60)
  logger.info('Returning a new browser driver')
  return global_driver

def open_tab(driver, loop_index, url):
  if loop_index == 0:
    driver.get(url)
  else:
    driver.execute_script("window.open('{}', '_blank')".format(url)) # https://stackoverflow.com/a/35405878

def open_tabs(driver, urls):
  for idx, url in enumerate(urls):
  	open_tab(driver, idx, url)

if __name__ == '__main__':
  # Usage: `./open_browser_tabs.py urls.csv`
  # relative path to the CSV containing the URLs
  # - sys.argv[0]: "./open_browser_tabs.py"
  # - sys.argv[1]: "urls.csv"
  urls_path = sys.argv[1]
  logger = logging.getLogger()
  urls = load_urls(urls_path)
  global_driver = get_global_driver()
  open_tabs(global_driver, urls)
