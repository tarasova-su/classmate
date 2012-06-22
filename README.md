Classmate
===========

Provides a set of classes, methods, and helpers to ease development of Odnoklassniki.ru applications with Rails.

Installation
------------

In order to install Classmate you should add it to your Gemfile:

    gem 'classmate'

Usage
-----

**Accessing Current User**

Current Classmate user data can be accessed using the ```current_classmate_user``` method:

    class UsersController < ApplicationController
      def profile
        @user = User.find_by_social_id(current_classmate_user.uid)
      end
    end

This method is also accessible as a view helper.

**Application Configuration**

In order to use Classmate you should set a default configuration for your Classmate application. The config file should be placed at RAILS_ROOT/config/classmate.yml

Sample config file:

    development:
      app_id: ...
      public_key: ...
      secret_key: ...
      namespace: your-app-namespace
      callback_domain: yourdomain.com

    test:
      app_id: ...
      public_key: ...
      secret_key: ...
      namespace: test
      callback_domain: callback.url
