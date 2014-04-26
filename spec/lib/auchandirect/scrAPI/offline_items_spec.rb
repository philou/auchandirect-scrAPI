# -*- encoding: utf-8 -*-
#
# spec/lib/auchandirect/scrAPI/offline_items_spec.rb
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

module Auchandirect
  module ScrAPI

    describe "OfflineAuchanDirectApi", slow: true do
      include_context "a scrapped store"
      it_should_behave_like "an API"

      def generate_store
        @offline_store_dir = File.join(AUCHANDIRECT_SCRAPI_ROOT_DIR,'offline_sites',WEBSITE)
        auchan_direct_offline = "file://" + File.join(@offline_store_dir, 'index.html')
        Storexplore::Api.browse(auchan_direct_offline)
      end

      it "collects names of item categories" do
        parseable_categories_attributes.each do |attributes|
          expect(attributes).to have_key(:name)
        end
      end

      it "parses promotions prices" do
        prices = items_with('prix-promo', "#produit-infos .bloc-prix-promo > span.prix-promo").
          map {|item_info| item_info[:item].attributes[:price] }

        expect(prices.first).to be_instance_of(Float)
      end

      it "collects secondary titles" do
        item_infos = items_with('titre-secondaire', '#produit-infos .titre-secondaire').first

        expect(item_infos[:item].attributes[:name]).to include(::Auchandirect::ScrAPI::Items::NAMES_SEPARATOR + item_infos[:elements].first.text)
      end

      private

      def items_with(grep_hint, selector)
        search_through_files_for(grep_hint, selector).
          map {|item_info| add_corresponding_item_to(item_info)}.
          select {|item_info| !item_info.nil? }
      end

      def search_through_files_for(grep_hint, selector)
        `find #{@offline_store_dir} -name *.html -exec grep -l "#{grep_hint}" {} \\;`.split("\n").lazy.

        map do |file|
          doc = Nokogiri::HTML(open(file))
          [file, doc.search(selector)]
        end.

        select do |file, elements|
          !elements.empty?
        end.

        map do |file, elements|
          split_url_to_tokens(file).merge(elements: elements)
        end
      end

      def split_url_to_tokens(file)
        # example : http://www.auchandirect.fr/petit-dejeuner-epicerie-sucree/chocolats,-confiseries/barres-biscuitees-muesli---cereales/id1/485/53869

        file = URI.unescape(file)
        file = file.gsub(/^.*\/www\.auchandirect\.fr\//, "")

        pieces = file.split("/").take(3)

        pieces[2] = pieces[2].split(",")[0]

        pieces = pieces.map do |piece|
          piece.gsub(/lv_/,'').split(/[\-_, \(\)']+/).select {|p| not (p.size <= 2 or p =~ /^[0-9]/)}
        end

        {cat_tokens: pieces[0], sub_cat_tokens: pieces[1], item_tokens: pieces[2]}
      end


      def add_corresponding_item_to(item_info)
        filter(store.categories, item_info[:cat_tokens]).each do |cat|
          filter(cat.categories, item_info[:sub_cat_tokens]).each do |sub_cat|
            sub_cat.categories.each do |sub_sub_cat|
              take_singleton(filter(sub_sub_cat.items, item_info[:item_tokens])).each do |item|
                return item_info.merge(item: item)
              end
            end
          end
        end
        nil
      end

      def filter(sub_elements, tokens)
        sub_elements.select do |element|
          tokens.all? do |token|
            element.attributes[:name].downcase.include?(token.downcase)
          end
        end
      end

      def take_singleton(items)
        item = nil

        begin
          item = items.next
        rescue StopIteration
          return []
        end

        begin
          items.next
        rescue StopIteration
          return [item]
        end

        return []
      end
    end
  end
end
