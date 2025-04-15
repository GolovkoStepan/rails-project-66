# frozen_string_literal: true

# == Schema Information
#
# Table name: users
#
#  id         :bigint           not null, primary key
#  email      :string           not null
#  image_url  :string
#  name       :string
#  nickname   :string
#  token      :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_users_on_email  (email) UNIQUE
#
class UserTest < ActiveSupport::TestCase
  def setup
    @user = users(:one)
  end

  test 'should be valid' do
    assert @user.valid?
  end

  test 'email should be present' do
    @user.email = ''
    assert_not @user.valid?
  end

  test 'email should be unique' do
    @user.email = users(:two).email
    assert_not @user.valid?
  end

  test 'should have many repositories' do
    assert_respond_to @user, :repositories
    assert_kind_of ActiveRecord::Associations::CollectionProxy, @user.repositories
  end

  test 'name should be optional' do
    @user.name = nil
    assert @user.valid?
  end

  test 'image_url should be optional' do
    @user.image_url = nil
    assert @user.valid?
  end

  test 'nickname should be optional' do
    @user.nickname = nil
    assert @user.valid?
  end

  test 'token should be optional' do
    @user.token = nil
    assert @user.valid?
  end
end
