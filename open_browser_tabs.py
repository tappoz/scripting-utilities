#!/usr/bin/env python3

print("\n\nUsage: `./open_browser_tabs.py open_browser_tabs.csv [firefox|chromium]`\n\n")

# INFO
# tested with Python 3.5.3

import os
import sys
import subprocess

# TODO opera --newwindow --newprivatetab google.com
# http://www.opera.com/docs/switches/
chromium_cmd_template = "chromium --incognito --new-window {} &"
firefox_cmd_template = "firefox -private {} &"

def load_urls(urls_path):
  with open(urls_path) as f:
    urls = f.readlines()
    urls = [x.strip().replace('\n', '') for x in urls]
  return urls

def __build_firefox_cmd(urls):
  firefox_urls_str = ''
  for idx, url in enumerate(urls):
    firefox_urls_str = firefox_urls_str + "-new-tab -url {} ".format(url)
  return firefox_cmd_template.format(firefox_urls_str)

def __build_chrome_cmd(urls):
  chromium_urls_str = ''
  for idx, url in enumerate(urls):
    chromium_urls_str = chromium_urls_str + ' ' + url
  return chromium_cmd_template.format(chromium_urls_str)

def open_tabs(urls, browser_name):
  if browser_name == 'firefox':
    browser_cmd = __build_firefox_cmd(urls)
  elif browser_name == 'chromium':
    browser_cmd = __build_chrome_cmd(urls)
  else:
    raise ValueError("Can not recognize this browser parameter: '{}'", browser_name)
  try:
    execution_stats = subprocess.run(browser_cmd, shell=True, check=True)
    print(execution_stats)
  except subprocess.CalledProcessError as e:
    sys.exit(1)

if __name__ == '__main__':
  urls_path = sys.argv[1]
  urls = load_urls(urls_path)
  browser_name = sys.argv[2]
  open_tabs(urls, browser_name)
