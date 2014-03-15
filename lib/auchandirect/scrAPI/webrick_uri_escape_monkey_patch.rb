# -*- encoding: utf-8 -*-
#
# lib/auchandirect/scrAPI/webrick_uri_escape_monkey_patch.rb
#
# Copyright (C) 2014 by Philippe Bourgau. All rights reserved.
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

require "webrick/httputils"

# monkey patch to avoid a regex uri encoding error when importing
#      incompatible encoding regexp match (ASCII-8BIT regexp with UTF-8 string) (Encoding::CompatibilityError)
#      .../webrick/httputils.rb:353:in `gsub'
#      .../webrick/httputils.rb:353:in `_escape'
#      .../webrick/httputils.rb:363:in `escape'
#      from uri method
#
# I would be glad to find a better way to fix this !

module WEBrick::HTTPUtils
  def self.escape(s)
    URI.escape(s)
  end
end
