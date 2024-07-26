#!/usr/local/bin/ruby

require File.dirname(__FILE__) + '/../config/environments/production'

def create_model_class(model_name, file_name, custom_table_name)
  File.open("app/models/" + file_name  + ".rb", "w", 0777) do |model_file|
    model_file.write <<EOF
require 'active_record'

class #{model_name} < ActiveRecord::Base
EOF
    if custom_table_name
      model_file.write <<EOF
  def self.table_name() '#{custom_table_name}' end
end
EOF
    else
      model_file.write "end\n"
    end
  end
end

def create_test_class(model_name, file_name, table_name)
    File.open("test/unit/" + file_name  + "_test.rb", "w", 0777) do |test_file|
        test_file.write <<EOF
require File.dirname(__FILE__) + '/../test_helper'
require '#{file_name}'

class #{model_name}Test < Test::Unit::TestCase
  def setup
    @#{table_name} = create_fixtures "#{table_name}"
  end

  def test_something
    assert true, "Test implementation missing"
  end
end
EOF
    end
end

def create_fixtures_directory(table_name)
  Dir.mkdir("test/fixtures/" + table_name) rescue puts "Fixtures directory already exists"
end


if !ARGV.empty?
  model_name = ARGV.shift
  file_name  = model_name.gsub(/([a-z])([A-Z])/, '\1_\2').downcase
  custom_table_name = ARGV.shift
  table_name = custom_table_name || ActiveRecord::Base.send(:undecorated_table_name, model_name)

  create_model_class(model_name, file_name, custom_table_name)
  create_test_class(model_name, file_name, table_name)
  create_fixtures_directory(table_name)
else
  puts <<-HELP

NAME
     new_model - create model stub files

SYNOPSIS
     new_model [model_name] (table_name)

DESCRIPTION
     The new_model generator takes the name of the new model and generates a model
     file in app/models that decents from ActiveRecord::Base but is otherwise empty.
     It then creates a model test suite in test/unit with one failing
     test case. Finally, it creates fixture directory in test/fixtures.

     The optional table_name argument can be used to override the automatic
     pluralization of the model name to generate the database table name.
     
EXAMPLE
     new_model Account
     
     This will generate a Account class in app/models/account.rb, a AccountTest in 
     test/unit/account_test.rb, and the directory test/fixtures/account.

HELP
end
