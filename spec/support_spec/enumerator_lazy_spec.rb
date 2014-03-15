# -*- encoding: utf-8 -*-
#
# spec/support_spec/enumerator_lazy_spec.rb
#
# Copyright (C) 2013, 2014 by Philippe Bourgau. All rights reserved.
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

describe Enumerator::Lazy, '#flatten' do

  it "returns the same collection as stock flatten" do
    tree = [[1], [1,2], [1,[2,3]]]
    expect(tree.lazy.flatten.to_a).to eq tree.flatten
    expect(tree.lazy.flatten(1).to_a).to eq tree.flatten(1)
    expect(tree.lazy.flatten(0).to_a).to eq tree.flatten(0)
  end

  it "processes items on demand" do
    processed_items = 0
    enums = (1..3).lazy.map {|i| (1..i).lazy.map {|j| processed_items += 1; j}}

    expect(enums.flatten.first(3)).to eq [1, 1,2]
    expect(processed_items).to eq 3
  end

  it "returns empty list for empty list" do
    expect([].lazy.flatten.to_a).to eq []
  end
end
