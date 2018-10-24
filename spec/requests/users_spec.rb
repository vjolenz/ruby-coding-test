require 'rails_helper'

RSpec.describe 'Users', type: :request do
  include UsersHelper
  context '#index' do
    it 'should lists users with show-edit-destroy buttons' do
      users = create_list(:user, 10)
      get users_path

      assert_select 'table tbody' do
        users.each do |user|
          assert_select 'td', user.first_name
          assert_select 'td', user.last_name
          assert_select 'td', user.email
          assert_select 'td a[href=?]', user_path(user), text: 'Show'
          assert_select 'td a[href=?]', edit_user_path(user), text: 'Edit'
          assert_select 'td a[href=?]', user_path(user), text: 'Destroy'
        end
      end
    end

    it 'should not display destroy button for admins' do
      admin = create(:admin_user)
      get users_path

      assert_select 'table tbody' do
        assert_select 'td a[href=?]', user_path(admin), count: 0, text: 'Destroy'
      end
    end
  end

  context '#new' do
    it 'should display form' do
      get new_user_path

      assert_select 'form[action=?][method=post]', users_path do
        assert_select 'input[name=?]', 'user[email]'
        assert_select 'input[name=?]', 'user[first_name]'
        assert_select 'input[name=?]', 'user[last_name]'
        assert_select 'input[type=submit]'
      end
    end
  end

  context '#create' do
    it 'should create user' do
      post users_path, params: { user: build(:user).attributes }
      expect(response).to redirect_to user_path(User.last)
    end

    it 'should display errors if user could not created' do
      user = User.new
      user.valid?
      error_messages = user.errors.full_messages

      post users_path, params: { user: user.attributes }
      expect(User.count).to eq 0
      error_messages.each { |msg| assert_select '#error_explanation ul li', msg }
    end
  end

  context '#show' do
    it "should display user's information and edit button" do
      user = create(:user)
      get user_path(user)

      assert_includes response.body, user.email
      assert_includes response.body, user.first_name
      assert_includes response.body, user.last_name
      all_emails_used_by(user).each do |email|
        assert_select 'ul li', email
      end
      assert_select 'a[href=?]', edit_user_path(user)
    end
  end

  context '#edit' do
    it 'should display form with inputs populated' do
      user = create(:user)
      get edit_user_path(user)

      assert_select 'form[action=?][method=post]', user_path(user) do
        assert_select 'input[name="user[email]"][value=?]', user.email
        assert_select 'input[name="user[first_name]"][value=?]', user.first_name
        assert_select 'input[name="user[last_name]"][value=?]', user.last_name
        assert_select 'input[type=submit]'
      end
    end
  end

  context '#update' do
    it 'should update user' do
      user = create(:user)
      new_attributes = build(:user).attributes.except('id', 'created_at', 'updated_at')

      patch user_path(user), params: { user: new_attributes }
      expect(user.reload.attributes.except('id', 'created_at', 'updated_at')).to eq new_attributes
      expect(response).to redirect_to user_path(user)
    end

    it 'should display errors if user could not updated' do
      invalid_user = User.new
      valid_user = create(:user)
      invalid_user.valid?

      patch user_path(valid_user), params: { user: invalid_user.attributes }
      expect(valid_user.reload).to eq valid_user
      invalid_user.errors.full_messages.each do |msg|
        assert_select '#error_explanation ul li', msg
      end
    end
  end

  context '#destroy' do
    it 'should destroy user' do
      user = create(:user)

      delete user_path(user)
      expect(User.where(id: user.id).first).to eq nil
      expect(response).to redirect_to users_path
    end

    it 'should display errors if user can not deleted' do
      # Since admins cant deleted we can use it to test behaviour
      admin = create(:admin_user)
      # Lets get error messages to test whether they are shown
      admin.destroy
      error_messages = admin.errors.full_messages

      delete user_path(admin)
      follow_redirect!

      expect { admin.reload }.not_to raise_error
      error_messages.each do |msg|
        assert_includes response.body, msg
      end
    end
  end
end
