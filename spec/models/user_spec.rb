require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'user creation' do
    it 'should verify the presence of the first name' do
      user = User.new(last_name: 'toto', email: 'toto@test.com', street: 'rue de lausanne', city: 'lausanne',
                      zip: 1600, password: 'hello world')
      expect(user).to_not be_valid
    end
    it 'should verify the presence of the last name' do
      user = User.new(first_name: 'toto', email: 'toto@test.com', street: 'rue de lausanne', city: 'lausanne',
                      zip: 1600, password: 'hello world')
      expect(user).to_not be_valid
    end

    it 'should verify the presence of the mail' do
      user = User.new(first_name: 'toto', last_name: 'toto', street: 'rue de lausanne', city: 'lausanne',
                      zip: 1600, password: 'hello world')
      expect(user).to_not be_valid
    end
    it 'should verify the presence of the street' do
      user = User.new(first_name: 'toto', last_name: 'toto', email: 'toto@test.com', city: 'lausanne',
                      zip: 1600, password: 'hello world')
      expect(user).to_not be_valid
    end
    it 'should verify the presence of the city' do
      user = User.new(first_name: 'toto', last_name: 'toto', email: 'toto@test.com', street: 'rue de lausanne',
                      zip: 1600, password: 'hello world')
      expect(user).to_not be_valid
    end
    it 'should verify the presence of the zip' do
      user = User.new(first_name: 'toto', last_name: 'toto', email: 'toto@test.com', street: 'rue de lausanne',
                      city: 'lausanne', password: 'hello world')
      expect(user).to_not be_valid
    end
    it 'should save successfully if everything is good' do
      user = User.new(first_name: 'toto', last_name: 'toto', email: 'toto@test.com', street: 'rue de lausanne',
                      city: 'lausanne', zip: 2000, password: 'hello world')
      expect(user).to be_valid
    end

    it 'two users should not be allowed to have the same email adress' do
      User.create(first_name: 'toto', last_name: 'toto', email: 'toto@test.com', street: 'rue de lausanne',
                  city: 'lausanne', zip: 2000, password: 'hello world')
      user2 = User.new(first_name: 'toto', last_name: 'toto', email: 'toto@test.com', street: 'rue de lausanne', city: 'lausanne',
                       zip: 2000, password: 'hello world')
      expect(user2).to_not be_valid
    end
  end
end
