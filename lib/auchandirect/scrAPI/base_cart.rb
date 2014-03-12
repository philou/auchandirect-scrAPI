# -*- encoding: utf-8 -*-
#
# auchandirect/scrAPI/base_carts.rb
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

    # Objects providing an api like access to third party online stores
    class BaseCart

      class << self
        alias :login :new
      end

      # main url of the store
      # def self.url
      def url
        self.class.url
      end

      # url at which a client browser can login
      # def self.login_url

      # parameters for a client side login
      # def self.login_parameters(login, password)

      # login and password parameters names
      # def self.login_parameter
      # def self.password_parameter

      # url at which a client browser can logout
      # def self.logout_url

      # logs in to the remote store
      # def initialize(login, password)

      # logs out from the store
      # def logout

      # total value of the remote cart
      # def cart_value

      # empties the cart of the current user
      # def empty_the_cart

      # adds items to the cart of the current user
      # def add_to_cart_cart(quantity, item_remote_id)

    end
  end
end
