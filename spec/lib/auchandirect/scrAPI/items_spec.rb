# -*- encoding: utf-8 -*-
#
# spec/lib/auchandirect/scrAPI/items_spec.rb
#
# Copyright (C) 2010-2014 by Philippe Bourgau. All rights reserved.
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

when_online "AuchanDirectStoreItemsAPI remote spec" do

  module Auchandirect
    module ScrAPI

      describe "AuchanDirectAPI", slow: true, remote: true do
        include_context "a scrapped store"
        it_should_behave_like "an API"

        def generate_store
          Auchandirect::ScrAPI::Items.browse
        end

        it "should have absolute urls for images" do
          expect(sample_items_attributes.map {|attr| attr[:image]}).to all_ {include("auchandirect.fr")}
        end

      end
    end
  end
end
