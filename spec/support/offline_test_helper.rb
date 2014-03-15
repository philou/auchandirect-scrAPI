# -*- encoding: utf-8 -*-
#
# spec/support/offline_test_helper.rb
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

require 'net/ping'

# Something to ask if we are online or not
module OfflineTestHelper

  # offline and onine predicates
  def offline?
    !online?
  end
  def online?
    @online ||= Net::Ping::TCP.new('www.google.com', 'http').ping?
  end

  # puts a colored warning if offline, otherwise
  def when_online(description)
    if offline?
      puts yellow("WARNING: skipping #{description} because running offline")
    else
      yield
    end
  end

  # something to color text
  def yellow(text)
    "\x1B[33m#{text}\x1B[0m"
  end

end
