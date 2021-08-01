#-- copyright
# OpenProject is an open source project management software.
# Copyright (C) 2012-2021 the OpenProject GmbH
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License version 3.
#
# OpenProject is a fork of ChiliProject, which is a fork of Redmine. The copyright follows:
# Copyright (C) 2006-2013 Jean-Philippe Lang
# Copyright (C) 2010-2013 the ChiliProject Team
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 2
# of the License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
#
# See docs/COPYRIGHT.rdoc for more details.
#++

require 'spec_helper'

describe MenuItem, type: :model do
  describe 'validations' do
    let(:item) { FactoryBot.build :menu_item }

    it 'requires a title' do
      item.title = nil
      expect(item).not_to be_valid
      expect(item.errors).to have_key :title
    end

    it 'requires a name' do
      item.name = nil
      expect(item).not_to be_valid
      expect(item.errors).to have_key :name
    end

    describe 'scoped uniqueness of title' do
      let!(:item) { FactoryBot.create :menu_item }
      let(:another_item) { FactoryBot.build :menu_item, title: item.title }
      let(:wiki_menu_item) { FactoryBot.build :wiki_menu_item, title: item.title }

      it 'does not allow for duplicate titles' do
        expect(another_item).not_to be_valid
        expect(another_item.errors).to have_key :title
      end

      it 'allows for creating a menu item with the same title if it has a different type' do
        expect(wiki_menu_item).to be_valid
      end
    end
  end

  context 'it should destroy' do
    let!(:menu_item) { FactoryBot.create(:menu_item) }
    let!(:child_item) { FactoryBot.create(:menu_item, parent_id: menu_item.id) }

    example 'all children when deleting the parent' do
      menu_item.destroy
      expect(MenuItem.exists?(child_item.id)).to be_falsey
    end
  end
end