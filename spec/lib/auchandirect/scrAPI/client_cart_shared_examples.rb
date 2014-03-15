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

shared_examples_for "Any Client Api" do |please_login_text|

  before :all do
    @please_login_text = please_login_text
  end

  it "logs in and out through HTTP" do
    @client = Mechanize.new
    expect(logged_in?).to(be_false, "should not be logged in at the begining")

    login
    expect(logged_in?).to(be_true, "should be logged in after submitting the login form")

    logout
    expect(logged_in?).to(be_false, "should he logged out after clicking the logout link")
  end

  private

  def logged_in?
    page = @client.get(@store_cart_api.url)
    !page.body.include?(@please_login_text)
  end

  def login
    params = @store_cart_api.login_parameters(@store_cart_api.valid_email, @store_cart_api.valid_password)
    post_params = params.map {|param| {param['name'] => param['value']}}.inject &:merge

    @client.post(@store_cart_api.login_url, post_params)
  end

  def logout
    @client.get(@store_cart_api.logout_url)
  end

end
