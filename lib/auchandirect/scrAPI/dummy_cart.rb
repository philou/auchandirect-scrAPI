# -*- encoding: utf-8 -*-
#
# auchandirect/scrAPI/dummy_cart.rb
#
# Copyright (c) 2011-2014 by Philippe Bourgau. All rights reserved.
#
# This library is free software; you can redistribute it and/or
# modify it under the terms of the GNU Lesser General Public
# License as published by the Free Software Foundation; either
# version 3.0 of the License, or (at your option) any later version.
#
# This library is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
# Lesser General Public License for more details.
#
# You should have received a copy of the GNU Lesser General Public
# License along with this library; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston,
# MA 02110-1301  USA

module Auchandirect
  module ScrAPI

    # A mock for Auchandirect::ScrAPI::Cart
    # It provides a call log as a way of testing
    class DummyCart < BaseCart

      def self.url
        "http://www.#{Storexplore::Testing::DummyStoreConstants::NAME}.com"
      end
      # The valid login to log into this dummy store
      def self.valid_email
        "valid@mail.com"
      end
      # The valid password to log into this dummy store
      def self.valid_password
        "valid-password"
      end

      def self.logout_url
        url+"/logout"
      end
      def self.login_url
        url+"/login"
      end
      def self.login_parameters(login,password)
        [{'name' => 'session_data', 'value' => 'crypted_data', 'type' => 'hidden'},
         {'name' => login_parameter, 'value' => login, 'type' => 'text'},
         {'name' => password_parameter, 'value' => password, 'type' => 'password'}]
      end
      def self.login_parameter
        'login'
      end
      def self.password_parameter
        'password'
      end

      # Accessors to the login and passwords used to login
      # And to the received messages log
      attr_reader :login, :password, :log

      def initialize(login = nil, password = nil)
        @log = []
        @login = ""
        @password = ""
        @unavailable_items = {}
        @content = Hash.new(0)

        if !login.nil? || !password.nil?
          relog(login, password)
        end
      end

      # Resets the session as if a new one was started
      def relog(login, password)
        if login != DummyCart.valid_email
          raise InvalidAccountError.new
        end

        @log.push(:login)
        @login = login
        @password = password
      end

      def logout
        @log.push(:logout)
      end

      def empty_the_cart
        @log.push(:empty_the_cart)
        @content.clear
      end

      def add_to_cart(quantity, item)
        if available?(item)
          @log.push(:add_to_cart)
          @content[item] += quantity
        end
      end

      def cart_value
        @content.to_a.inject(0.0) do |amount,id_and_quantity|
          item = id_and_quantity.first
          quantity = id_and_quantity.last

          unit_price = item.hash.abs.to_f/1e7

          amount + quantity * unit_price
        end
      end

      # Collection of all the different items in the cart
      def content
        @content.keys
      end

      # Is the cart empty ?
      def empty?
        @content.empty?
      end

      # Does the cart contain the specified quantity of this item ?
      def containing?(item, quantity)
        @content[item] == quantity
      end

      # Makes an item temporarily unavailable
      def add_unavailable_item(item)
        @unavailable_items[item] = true
      end

      # Is the given item available at this moment ?
      def available?(item)
        !@unavailable_items[item]
      end

    end
  end
end
