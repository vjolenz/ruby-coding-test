require 'rails_helper'

RSpec.describe User, type: :model do
  context 'validations' do
    it { should validate_presence_of :first_name }
    it { should validate_presence_of :last_name }
    it { should validate_presence_of :email }
    it { should validate_uniqueness_of(:email).ignoring_case_sensitivity }
    it { should_not allow_value('mail').for :email }
    it { should_not allow_value('mail#notvalid.com').for :email }
    it { should_not allow_value('mail@notvalid').for :email }
  end

  context 'email' do
    it 'should downcase' do
      user = build(:user, email: 'JANE@FBI.GOV')

      expect(user.email).to eq 'jane@fbi.gov'
    end

    it 'should strip whitespaces' do
      user = build(:user, email: '     JANE@FBI.GOV ')

      expect(user.email).to eq 'jane@fbi.gov'
    end

    it 'should not raise error when nil provided' do
      expect { build(:user, email: nil) }.not_to raise_error
    end

    it 'audits changes' do
      user = create(:user)
      email_before_change = user.email
      user.update_attributes! email: 'fancy@email.com'

      expect(user.audits.last.audited_changes['email'].first).to eq email_before_change
    end
  end

  context 'status' do
    it 'should be non-customer if status is not set' do
      user = create(:user, status: nil)
      expect(user.reload.non_customer?).to be true
    end
  end

  context 'when user is admin' do
    it 'cant be destroyed' do
      admin = create(:admin_user)
      admin.destroy
      expect { admin.reload }.not_to raise_error
    end
  end

end