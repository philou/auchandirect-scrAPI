# -*- encoding: utf-8 -*-
#
# spec/lib/auchandirect/scrAPI/cart_spec.rb
#
# Copyright (C) 2011-2014 by Philippe Bourgau. All rights reserved.
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

require 'spec_helper'
require_relative 'cart_shared_examples'
require_relative 'client_cart_shared_examples'

when_online("AuchanDirectApi remote spec") do

  module Auchandirect
    module ScrAPI

      module AuchanDirectApiCredentials
        def valid_email
          check_credentials
          ENV['AUCHANDIRECT_TEST_EMAIL']
        end
        def valid_password
          check_credentials
          ENV['AUCHANDIRECT_TEST_PASSWORD']
        end

        private
        def check_credentials
          if ENV['AUCHANDIRECT_TEST_EMAIL'].to_s.empty? or ENV['AUCHANDIRECT_TEST_PASSWORD'].to_s.empty?
            raise RuntimeError.new("Please specify valid auchandirect credentials with env AUCHANDIRECT_TEST_EMAIL and AUCHANDIRECT_TEST_PASSWORD when running these specs")
          end
        end
      end
      # force autoload of AuchanDirectApi
      Auchandirect::ScrAPI::Cart.send(:extend, AuchanDirectApiCredentials)

      describe Auchandirect::ScrAPI::Cart, slow: true, remote: true do
        it_should_behave_like "Any Cart", Auchandirect::ScrAPI::Cart, Auchandirect::ScrAPI::Items.url
        it_should_behave_like "Any Client Cart", Auchandirect::ScrAPI::Cart, "Identifiez-vous"
      end
    end
  end
end


