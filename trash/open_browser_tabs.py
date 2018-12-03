#!/usr/bin/env python2

# TODO move to a command like this: `chromium --incognito firefox.com ubuntu.com duckduckgo.com &`

import os
import sys

# import threading

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
  chrome_options.add_argument("user-data-dir={}/.config/chromium".format(os.environ['HOME']))
  chrome_options.add_argument("disable-infobars")
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
  print(0)
  global_driver = webdriver.Chrome(chrome_options=get_chrome_options())
  print(1)
  global_driver.set_window_size(1366, 768)
  print(2)
  global_driver.implicitly_wait(5) # seconds
  print(3)
  global_driver.set_page_load_timeout(60)
  print(4)
  global_driver.set_script_timeout(60)
  print(5)
  global_driver.maximize_window()
  print("Done tuning the browser, returning")
  return global_driver

def open_tab(driver, loop_index, url):
  print("Loop index {}, opening URL: {}".format(loop_index, url))
  if loop_index == 0:
    driver.get(url)
  else:
    driver.execute_script("window.open('{}', '_blank')".format(url)) # https://stackoverflow.com/a/35405878

def open_tabs(driver, urls):
  for idx, url in enumerate(urls):
  	open_tab(driver, idx, url)

# def start_browser_with_tabs(urls_path):

if __name__ == '__main__':
  # Usage: `./open_browser_tabs.py urls.csv`
  # relative path to the CSV containing the URLs
  # - sys.argv[0]: "./open_browser_tabs.py"
  # - sys.argv[1]: "urls.csv"
  urls_path = sys.argv[1]
  urls = load_urls(urls_path)
  global_driver = get_global_driver()
  print("Opening URLs")
  open_tabs(global_driver, urls)
  # browser_thread = threading.Thread(target=start_browser_with_tabs, args=(urls_path,))
  # browser_thread.start()
  # start_browser_with_tabs(urls_path)
