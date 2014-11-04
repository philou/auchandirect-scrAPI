# -*- encoding: utf-8 -*-
#
# spec_helper.rb
#
# Copyright (c) 2013-2014 by Philippe Bourgau. All rights reserved.
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

require "codeclimate-test-reporter"
CodeClimate::TestReporter.start

require 'auchandirect/scrAPI'
require 'rspec/collection_matchers'
require 'spec_combos'

# Offline testing
require_relative 'support/offline_test_helper'
require_relative 'support/enumerator_lazy'
include OfflineTestHelper

# Gem root dir
AUCHANDIRECT_SCRAPI_ROOT_DIR = File.join(File.dirname(__FILE__), '..')

# Dummy store generation
require 'storexplore/testing'
Storexplore::Testing.config do |config|
  config.dummy_store_generation_dir= File.join(AUCHANDIRECT_SCRAPI_ROOT_DIR, 'tmp')
end

# Timeout examples when they take more that 1 minute
require 'timeout'
RSpec.configure do |c|
  c.around(:each) do |example|
    Timeout::timeout(60) {
      example.run
    }
  end
end
