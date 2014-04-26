# -*- encoding: utf-8 -*-
#
# auchandirect/scrAPI/cart.rb
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

require 'json'

module Auchandirect
  module ScrAPI

    # Cart API for AuchanDirect store
    class Cart < BaseCart

      # Main url of the store
      def self.url
        HOMEPAGE
      end

      # Logins to auchan direct store
      def initialize(login, password)
        @agent = Mechanize.new
        do_login(login, password)
        raise InvalidAccountError unless logged_in?
      end

      # Url at which a client browser can login
      def self.login_url
        URL + login_path
      end
      # Parameters for a client side login
      def self.login_parameters(login, password)
        default_params = post_parameters.map {|name, value| {'name' => name, 'value' => value, 'type' => 'hidden'}}
        user_params = [{'name' => FORMDATA_PARAMETER, 'value' => login_form_data(Mechanize.new), 'type' => 'hidden'},
                       {'name' => LOGIN_PARAMETER, 'value' => login, 'type' => 'text'},
                       {'name' => PASSWORD_PARAMETER, 'value' => password, 'type' => 'password'}]

        default_params + user_params
      end

      # Client side 'login' parameter name
      def self.login_parameter
        LOGIN_PARAMETER
      end
      # Client side 'password' parameter name
      def self.password_parameter
        PASSWORD_PARAMETER
      end

      # Url at which a client browser can logout
      def self.logout_url
        URL + logout_path
      end

      # Logs out from the store
      def logout
        get(self.class.logout_path)
      end

      # Total value of the remote cart
      def cart_value
        cart_page = get("/monpanier")
        cart_page.search("span.prix-total").first.content.gsub(/€$/,"").to_f
      end

      # Empties the cart of the current user
      def empty_the_cart
        post("/boutiques.blockzones.popuphandler.cleanbasketpopup.cleanbasket")
      end

      # Adds items to the cart of the current user
      def add_to_cart(quantity, item_remote_id)
        quantity.times do
          post("/boutiques.mozaique.thumbnailproduct.addproducttobasket/#{item_remote_id}")
        end
      end

      # Missing methods can be forwarded to the class
      def method_missing(method_sym, *arguments, &block)
        if delegate_to_class?(method_sym)
          self.class.send(method_sym, *arguments, &block)
        else
          super
        end
      end

      # It can respond to messages that the class can handle
      def respond_to?(method_sym)
        super or delegate_to_class?(method_sym)
      end

      private

      def do_login(login,password)
        formdata = login_form_data(@agent)

        post(login_path,
             FORMDATA_PARAMETER => formdata,
             LOGIN_PARAMETER => login,
             PASSWORD_PARAMETER => password)
      end

      def self.login_path
        "/boutiques.blockzones.popuphandler.authenticatepopup.authenticateform"
      end

      def self.login_form_data(agent)
        home_page = agent.get(Cart.url)

        with_retry(5) do
          login_form_json = post(agent, "/boutiques.paniervolant.customerinfos:showsigninpopup", {}, {'Referer' => home_page.uri})

          html_body = JSON.parse(login_form_json.body)["zones"]["popupZone"]
          doc = Nokogiri::HTML("<html><body>#{html_body}</body></html>")
          doc.xpath("//input[@name='#{FORMDATA_PARAMETER}']/@value").first.content
        end
      end

      def self.with_retry(attempts)
        begin
          return yield

        rescue Exception => e
          attempts -= 1

          retry unless attempts == 0
          raise e
        end
      end

      def logged_in?
        main_page = get("/Accueil")
        !main_page.body.include?("Identifiez-vous")
      end

      def get(path)
        @agent.get(URL + path)
      end

      def post(path, parameters = {}, headers = {})
        self.class.post(@agent, path, parameters, headers)
      end

      def self.post(agent, path, parameters = {}, headers = {})
        agent.post(URL + path, post_parameters.merge(parameters), fast_header.merge(headers))
      end

      def self.fast_header
        {'X-Requested-With' => 'XMLHttpRequest'}
      end

      def self.logout_path
        parametrized_path("/boutiques.paniervolant.customerinfos:totallogout", post_parameters)
      end

      def self.parametrized_path(path, parameters)
        string_parameters = parameters.map do |key,value|
          "#{key}=#{value}"
        end
        "#{path}?#{string_parameters.join('&')}"
      end

      def self.post_parameters
        {'t:ac' => "Accueil", 't:cp' => 'gabarit/generated'}
      end

      def delegate_to_class?(method_sym)
        self.class.respond_to?(method_sym)
      end

      FORMDATA_PARAMETER = 't:formdata'
      LOGIN_PARAMETER = 'inputLogin'
      PASSWORD_PARAMETER = 'inputPwd'
    end
  end
end
