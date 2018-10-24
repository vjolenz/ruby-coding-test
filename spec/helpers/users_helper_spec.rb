require 'rails_helper'

RSpec.describe UsersHelper, type: :helper do
  context '#all_emails_used_by' do
    it 'returns all emails used from newest to oldest' do
      emails = ['first@email.com', 'second@email.com', 'third@email.com']
      user = create(:user, email: emails[0])
      user.update_attributes!(email: emails[1])
      user.update_attributes!(email: emails[2])

      expect(helper.all_emails_used_by(user).reverse).to eq emails
    end

    it 'returns distinct emails' do
      user = create(:user, email: 'first@email.com')
      user.update_attributes!(email: 'second@email.com')
      user.update_attributes!(email: 'third@email.com')
      user.update_attributes!(email: 'second@email.com')
      user.update_attributes!(email: 'third@email.com')

      expect(helper.all_emails_used_by(user)).to eq ['third@email.com', 'second@email.com', 'first@email.com']
    end
  end
end
