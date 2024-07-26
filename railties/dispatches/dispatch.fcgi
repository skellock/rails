#!/usr/local/bin/ruby

require File.dirname(__FILE__) + "/../config/environments/production"
require 'dispatcher'

FCGI_PURE_RUBY = true
require 'fcgi'

FCGI.each_cgi { |cgi| Dispatcher.dispatch(cgi, Dispatcher::DEFAULT_SESSION_OPTIONS, File.dirname(__FILE__) + "/500.html") }