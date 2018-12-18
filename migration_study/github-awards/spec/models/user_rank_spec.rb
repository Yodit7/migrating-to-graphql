require 'rails_helper'

describe "UserRank" do
  
  let(:user) { FactoryGirl.create(:user, city: "paris", country: "france") }
  let(:user_rank) { UserRank.new(user, "ruby", 10, 4) }
  
  describe "stars_count" do
    it { expect(user_rank.stars_count).to eq(10) }
  end
  
  describe "repository_count" do
    it { expect(user_rank.repository_count).to eq(4) }
  end
  
  describe "city" do
    before(:each) do
      $redis.zadd("user_ruby_paris", 1.1, 1234)
      $redis.zadd("user_ruby_paris", 5.0, 1235)
      $redis.zadd("user_ruby_paris", 3.2, user.id)
    end
    
    it { expect(user_rank.city_rank).to eq(2) }
    it { expect(user_rank.city_user_count).to eq(3) }
  end
  
  describe "country" do
    before(:each) do
      $redis.zadd("user_ruby_france", 1.1, 1234)
      $redis.zadd("user_ruby_france", 5.0, 1235)
      $redis.zadd("user_ruby_france", 6.2, user.id)
    end
    
    it { expect(user_rank.country_rank).to eq(1) }
    it { expect(user_rank.country_user_count).to eq(3) }
  end
  
  describe "world" do
    before(:each) do
      $redis.zadd("user_ruby", 1.1, 1234)
      $redis.zadd("user_ruby", 5.0, 1235)
      $redis.zadd("user_ruby", 0.2, user.id)
    end
    
    it { expect(user_rank.world_rank).to eq(3) }
    it { expect(user_rank.world_user_count).to eq(3) }
  end
  
  describe "rank" do
    context "user has changed location" do
      it "updates ranking" do
        FactoryGirl.create(:repository, user: user, language: "ruby", stars: 5)
        expect(user_rank.city_rank).to eq(1)
      end
    end
  end



end