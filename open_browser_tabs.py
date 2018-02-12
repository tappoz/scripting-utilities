#!/usr/bin/env python3

# INFO
# tested with Python 3.5.3

import os
import sys
import subprocess

# TODO choose browser with command line parameter
chromium_cmd_template = "chromium --incognito {} &"
firefox_cmd_template = "firefox -private {} &"

def load_urls(urls_path):
  with open(urls_path) as f:
    urls = f.readlines()
    urls = [x.strip().replace('\n', '') for x in urls]
  return urls

def open_tabs(urls):
  chromium_urls_str = ''
  firefox_urls_str = ''
  for idx, url in enumerate(urls):
    chromium_urls_str = chromium_urls_str + ' ' + url
    firefox_urls_str = firefox_urls_str + "-new-tab -url {} ".format(url)
  chromium_browser_cmd = chromium_cmd_template.format(chromium_urls_str)
  firefox_browser_cmd = firefox_cmd_template.format(firefox_urls_str)
  try:
    execution_stats = subprocess.run(firefox_browser_cmd, shell=True, check=True)
    print(execution_stats)
  except subprocess.CalledProcessError as e:
    sys.exit(1)

if __name__ == '__main__':
  urls_path = sys.argv[1]
  urls = load_urls(urls_path)
  open_tabs(urls)
