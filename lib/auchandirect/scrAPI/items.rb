# -*- encoding: utf-8 -*-
#
# auchandirect/scrAPI/items.rb
#
# Copyright (c) 2010-2014 by Philippe Bourgau. All rights reserved.
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

    # Storexplore api definition to browse all the items available
    # at auchandirect.com
    # See[https://github.com/philou/storexplore/blob/master/README.md]
    #
    # The store has 3 depths of categories.
    # The only attribute the categories have is their name
    # The items are all child of the bottom categories, here are
    # their attributes
    # * brand
    # * name
    # * price
    # * image (url of the link to the image)
    # * remote_id (the id of this item in the auchandirect database)

    module Items
      NAMES_SEPARATOR = ', '
    end

    Storexplore::Api.define "auchandirect.fr" do

      categories '#footer-menu h2 a' do
        attributes do
          { name: page.get_one('#content .titre-principal').content }
        end

        categories '#content .menu-listes h2 a' do
          attributes do
            { name: page.get_one('#content .titre-principal').content }
          end

          categories '#content .bloc_prd > a' do
            attributes do
              { :name => page.get_one("#wrap-liste-produits-nav .titre-principal").content }
            end

            items '.infos-produit-2 > a' do
              attributes do
                {
                  :brand => page.get_one('#produit-infos .titre-principal').content,
                  :name => page.get_all('#produit-infos .titre-annexe, #produit-infos .titre-secondaire', Items::NAMES_SEPARATOR),
                  :price => page.get_one('#produit-infos .prix-actuel > span, #produit-infos .bloc-prix-promo > span.prix-promo').content.to_f,
                  :image => page.get_image('#produit-infos img.produit').url.to_s,
                  :remote_id => /\/([^\/\.]*)[^\/]*$/.match(uri.to_s)[1]
                }
              end
            end
          end
        end
      end
    end
  end
end
