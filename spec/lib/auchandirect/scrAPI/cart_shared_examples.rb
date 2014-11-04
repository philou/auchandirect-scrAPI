# -*- encoding: utf-8 -*-
#
# spec/lib/auchandirect/scrAPI/cart_shared_examples.rb
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

shared_examples_for "Any Cart" do |store_cart_class, store_url|

  before :all do
    @store_cart_class = store_cart_class
    @store_url = store_url
  end

  it "should know its logout url" do
    logout_url = store_cart_class.logout_url

    expect(logout_url).to(match(URI.regexp(['http'])), "#{logout_url} is not an http url !")
  end

  it "should know its login url" do
    expect(store_cart_class.login_url).not_to be_empty
  end

  it "should know its login parameters" do
    expect(store_cart_class.login_parameters(store_cart_class.valid_email, store_cart_class.valid_password)).not_to be_nil
  end

  {login_parameter: 'text', password_parameter: 'password'}.each do |parameter_reader, html_input_type|
    it "should know its #{parameter_reader} name" do
      parameter_name = store_cart_class.send(parameter_reader)
      expect(parameter_name).not_to be_empty

      param = store_cart_class.login_parameters("","").find{|param| param['name'] == parameter_name}
      expect(param).not_to be_nil
      expect(param['type']).to eq(html_input_type)
    end
  end

  it "should raise when login in with an invalid account" do
    expect(lambda {
             store_cart_class.login("unknown-account", "wrong-password")
           }).to raise_error(Auchandirect::ScrAPI::InvalidAccountError)
  end

  context "with a valid account" do

    attr_reader :sample_item_id, :another_item_id, :store_cart_api

    before(:all) do
      @session = new_session

      sample_items = extract_sample_items
      sample_item = sample_items.next
      @sample_item_id = sample_item.attributes[:remote_id]
      @another_item_id = extract_another_item_id(sample_items, sample_item)
    end
    before(:each) do
      @session.empty_the_cart
    end

    after(:all) do
      @session.logout unless @session.nil?
    end

    # Some tests are redudant with what is item extractions, but the followings
    # are clearer about what is expected from the cart

    it "should set the cart value to 0 when emptying the cart" do
      @session.add_to_cart(1, sample_item_id)

      @session.empty_the_cart
      expect(@session.cart_value).to eq 0
    end

    it "should set the cart value to something greater than 0 when adding items to the cart" do
      @session.empty_the_cart

      @session.add_to_cart(1, sample_item_id)
      expect(@session.cart_value).to be > 0
    end

    it "should set the cart value to 2 times that of one item when adding 2 items" do
      @session.empty_the_cart

      @session.add_to_cart(1, sample_item_id)
      item_price = @session.cart_value

      @session.add_to_cart(1, sample_item_id)
      expect(@session.cart_value).to eq 2*item_price
    end

    it "should set different cart values with different items" do
      sample_item_cart_value = cart_value_with_item(sample_item_id)
      another_item_cart_value = cart_value_with_item(another_item_id)

      expect(sample_item_cart_value).not_to eq another_item_cart_value
    end

    it "should save the cart between sessions" do
      @session.add_to_cart(1, sample_item_id)
      @session.logout

      @session = new_session

      expect(@session.cart_value).not_to eq 0
    end

    it "should save the cart between sessions, even while another session" do
      background_session = @session

      run_session do |session|
        session.add_to_cart(1, sample_item_id)
      end

      run_session do |session|
        expect(session.cart_value).not_to eq 0
      end
    end

    private

    def run_session
      session = new_session
      begin
        yield session
      ensure
        session.logout
      end
    end

    def new_session
      @store_cart_class.login(@store_cart_class.valid_email, @store_cart_class.valid_password)
    end
    def extract_another_item_id(sample_items, sample_item)
      another_item = sample_item
      while sample_item.attributes[:price] == another_item.attributes[:price]
        another_item = sample_items.next
      end
      another_item.attributes[:remote_id]
    end

    def extract_sample_items
      extract_sample_items_from(Storexplore::Api.browse(@store_url))
    end

    def extract_sample_items_from(category)
      items = find_available_items(category)

      sub_items = nationaly_available_first(category.categories).lazy.map do |sub_category|
        extract_sample_items_from(sub_category)
      end

      [items, sub_items].lazy.flatten
    end

    def find_available_items(category)
      nationaly_available_first(category.items)
        .find_all {|item| item_available?(item.attributes[:remote_id]) }
    end

    def item_available?(item_id)
      @session.empty_the_cart
      @session.add_to_cart(1, item_id)
      item_price = @session.cart_value
      return false if 0 == item_price

      @session.add_to_cart(1, item_id)
      return @session.cart_value == item_price * 2
    end

    def nationaly_available_first(elements)
      # Sometimes the tests used to fail because the sample item was not available
      # in the geographical region of the test user.
      milks, others = elements.partition { |element| is_milk(element) }
      milks + others
    end

    def is_milk(element)
      ["lait", "crème"].any? do |word|
        element.title.downcase.include?(word)
      end
    end

    def cart_value_with_item(item_id)
      @session.empty_the_cart
      @session.add_to_cart(1, item_id)
      @session.cart_value
    end
  end
end
