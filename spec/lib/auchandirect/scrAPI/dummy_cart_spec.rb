# -*- encoding: utf-8 -*-
#
# spec/lib/auchandirect/scrAPI/dummy_cart_spec.rb
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
require 'storexplore/testing'

module Auchandirect
  module ScrAPI

    describe Auchandirect::ScrAPI::DummyCart do
      STORE_NAME = "www.cart-dummy-api-spec.com"

      it_should_behave_like "Any Cart", Auchandirect::ScrAPI::DummyCart, Storexplore::Testing::DummyStore.uri(STORE_NAME)

      before(:all) do
        Storexplore::Testing::DummyStore.wipe_out_store(STORE_NAME)
        Storexplore::Testing::DummyStore.open(STORE_NAME).generate(3).categories.and(3).categories.and(3).items
      end
    end
  end
end
