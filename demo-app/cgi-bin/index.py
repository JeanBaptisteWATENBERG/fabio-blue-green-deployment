#!/usr/bin/env python3
import os
print("Content-Type: text/html\n")
print("<!doctype html><title>Hello</title><h2>hello world - " + os.getenv('HOSTNAME', 'localhost') + " - version is " + os.getenv('VERSION', 'default') + "</h2>")
