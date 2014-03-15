# -*- encoding: utf-8 -*-
#
# spec/support/enumerator_lazy.rb
#
# Copyright (C) 2013-2014 by Philippe Bourgau. All rights reserved.
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

class Enumerator::Lazy

  def flatten(depth = Float::INFINITY)
    return self if depth <= 0

    Enumerator::Lazy.new(self) do |yielder, item|
      if item.is_a? Enumerable
        item.lazy.flatten(depth - 1).each do |e|
          yielder.yield(e)
        end
      else
        yielder.yield(item)
      end
    end
  end

end
