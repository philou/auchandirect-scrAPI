# -*- encoding: utf-8 -*-
#
# spec/lib/auchandirect/scrAPI/client_cart_shared_examples.rb
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

shared_examples_for "Any Client Cart" do |store_cart_class, please_login_text|

  before :all do
    @store_cart_class = store_cart_class
    @please_login_text = please_login_text
  end

  it "logs in and out through HTTP" do
    @client = @store_cart_class.new_agent
    expect(logged_in?).to (be false), "should not be logged in at the begining"

    login
    expect(logged_in?).to (be true), "should be logged in after submitting the login form"

    logout
    expect(logged_in?).to (be false), "should he logged out after clicking the logout link"
  end

  private

  def logged_in?
    page = @client.get(@store_cart_class.url)
    !page.body.include?(@please_login_text)
  end

  def login
    params = @store_cart_class.login_parameters(@store_cart_class.valid_email, @store_cart_class.valid_password)
    post_params = params.map {|param| {param['name'] => param['value']}}.inject &:merge

    @client.post(@store_cart_class.login_url, post_params)
  end

  def logout
    @client.get(@store_cart_class.logout_url)
  end

end
