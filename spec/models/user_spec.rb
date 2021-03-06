require 'spec_helper'

describe User do
  
  describe :validations do
    it { should have_many :payments }
    it { should have_many :subscriptions }
    it { should have_many :memberships }
    it { should have_many :organization_embeds }
    it { should have_many :organizations }
    it { should have_many :ownerships }
    it { should have_many :current_ownerships }
    it { should have_many :owned_bikes }
    it { should have_many :currently_owned_bikes }
    it { should have_many :integrations }
    it { should have_many :created_ownerships }
    it { should have_many :bike_tokens }
    it { should have_many :locks }
    it { should have_many :organization_invitations }
    it { should have_many :oauth_applications }
    it { should have_many :sent_stolen_notifications }
    it { should have_many :received_stolen_notifications }
    it { should serialize :paid_membership_info }
    it { should serialize :my_bikes_hash }
    it { should validate_presence_of :email }
    it { should validate_uniqueness_of :email }
  end

  describe :validate do
    describe :create do
      before :each do
        @user = User.new(FactoryGirl.attributes_for(:user))
        @user.valid?.should be_true
      end

      it "requires password on create" do 
        @user.password = nil
        @user.password_confirmation = nil
        @user.valid?.should be_false
        @user.errors.messages[:password].include?("can't be blank").should be_true
      end

      it "requires password and confirmation to match" do
        @user.password_confirmation = "wtf"
        @user.valid?.should be_false
        @user.errors.messages[:password].include?("doesn't match confirmation").should be_true
      end

      it "requires at least 8 characters for the password" do
        @user.password = 'hi'
        @user.password_confirmation = 'hi'
        @user.valid?.should be_false
        @user.errors.messages[:password].include?('is too short (minimum is 6 characters)').should be_true
      end

      it "makes sure there is at least one letter" do
        @user.password = '1234567890'
        @user.password_confirmation = '1234567890'
        @user.valid?.should be_false
        @user.errors.messages[:password].include?('must contain at least one letter').should be_true
      end
    end

    describe :confirm do
      before :each do
        @user = FactoryGirl.create(:user)
      end

      it "requires confirmation" do
        @user.confirmed.should be_false
        @user.confirmation_token.should_not be_nil
      end

      it "confirms users" do
        @user.confirm(@user.confirmation_token).should be_true
        @user.confirmed.should be_true
        @user.confirmation_token.should be_nil
      end

      it "fails to confirm users" do
        @user.confirm("wtfmate").should be_false
        @user.confirmed.should be_false
        @user.confirmation_token.should_not be_nil
      end

      it "is bannable" do
        @user.banned = true
        @user.save
        @user.authenticate('testme21').should == false
      end
    end

    describe :update do
      before :each do
        @user = FactoryGirl.create(:user)
        @user.valid?.should be_true
      end

      it "does not require a password on update" do
        @user.save
        @user.password = nil
        @user.password_confirmation = nil
        @user.valid?.should be_true
      end


      it "requires password and confirmation to match" do
        @user.password_confirmation = "wtf"
        @user.valid?.should be_false
        @user.errors.messages[:password].include?("doesn't match confirmation").should be_true
      end

      it "requires at least 8 characters for the password" do
        @user.password = 'hi'
        @user.password_confirmation = 'hi'
        @user.valid?.should be_false
        @user.errors.messages[:password].include?('is too short (minimum is 6 characters)').should be_true
      end

      it "makes sure there is at least one letter" do
        @user.password = '1234567890'
        @user.password_confirmation = '1234567890'
        @user.valid?.should be_false
        @user.errors.messages[:password].include?('must contain at least one letter').should be_true
      end
    end
  end

  describe :admin_authorized do 
    before :all do
      @content = FactoryGirl.create(:user, is_content_admin: true)
      @admin = FactoryGirl.create(:admin)
    end

    it "auths full" do 
      @admin.admin_authorized('full').should be_true
      @content.admin_authorized('full').should be_false
    end

    it "auths content" do 
      @admin.admin_authorized('content').should be_true
      @content.admin_authorized('content').should be_true
    end

    it "auths any" do 
      @admin.admin_authorized('any').should be_true
      @content.admin_authorized('any').should be_true
    end
  end

  describe :fuzzy_email_find do
    it "finds users by email address when the case doesn't match" do
      @user = FactoryGirl.create(:user, email: "ned@foo.com")
      User.fuzzy_email_find('NeD@fOO.coM').should == @user
    end
  end

  describe :set_urls do
    xit "adds http:// to twitter and website if the url doesn't have it so that the link goes somewhere" do
      user = User.new(show_twitter: true, twitter: "http://somewhere.com", show_website: true, website: "somewhere.org" )
      user.set_urls
      user.website.should eq('http://somewhere.org')
    end
    it "does not add http:// to twitter if it's already there" do
      user = User.new(show_twitter: true, twitter: "http://somewhere.com", show_website: true, website: "somewhere", my_bikes_link_target: 'https://something.com')
      user.set_urls
      user.my_bikes_hash[:link_target].should eq('https://something.com')
      user.twitter.should eq('http://somewhere.com')
    end
  end

  describe :set_phone do
    it "strips the non-digit numbers from the phone input" do
      @user = FactoryGirl.create(:user, phone: '773.83ddp+83(887)')
      @user.phone.should eq('7738383887')
    end
  end

  describe :bikes do
    it "returns nil if the user has no bikes" do
      user = FactoryGirl.create(:user)
      user.bikes.should be_empty
    end
    it "returns the user's bikes if they have any hidden bikes without the hidden bikes" do
      user = FactoryGirl.create(:user)
      o = FactoryGirl.create(:ownership, owner_email: user.email, user_id: user.id)
      o2 = FactoryGirl.create(:ownership, owner_email: user.email, user_id: user.id)
      o2.bike.update_attribute :hidden, true
      user.bike_ids.include?(o.bike.id).should be_true
      user.bike_ids.include?(o2.bike.id).should_not be_true
      user.bike_ids.count.should eq(1)
    end
    it "returns the user's bikes if they have any hidden bikes without the hidden bikes" do
      user = FactoryGirl.create(:user)
      ownership = FactoryGirl.create(:ownership, owner_email: user.email, user_id: user.id, user_hidden: true)
      ownership.bike.update_attribute :hidden, true
      user.bike_ids.include?(ownership.bike.id).should be_true
    end
    it "returns the user's bikes without hidden bikes if user_hidden" do
      user = FactoryGirl.create(:user)
      ownership = FactoryGirl.create(:ownership, owner_email: user.email, user_id: user.id, user_hidden: true)
      ownership.bike.update_attribute :hidden, true
      user.bike_ids(false).include?(ownership.bike.id).should be_false
    end
  end

  describe :available_bike_tokens do
    before :each do
      @organization = FactoryGirl.create(:organization)
      @user = FactoryGirl.create(:user)
      5.times do
        FactoryGirl.create(:bike_token, user: @user, organization: @organization)
      end
      @bike = FactoryGirl.create(:bike)
    end

    it "returns the available bike tokens" do
      @user.available_bike_tokens.count.should eq(5)
      @user.available_bike_tokens.first.destroy
      @user.available_bike_tokens.count.should eq(4)
      @user.available_bike_tokens.first.update_column(:bike_id, @bike)
      @user.available_bike_tokens.count.should eq(3)
    end
  end

  describe :generate_username_confirmation_and_auth do 
    it "generates the required tokens" do 
      user = FactoryGirl.create(:user)
      user.auth_token.should be_present
      user.username.should be_present
      user.confirmation_token.should be_present
      time = Time.at(user.auth_token.match(/\d*\z/)[0].to_i)
      time.should be > Time.now - 1.minutes
    end
    it "haves before create callback" do 
      User._create_callbacks.select { |cb| cb.kind.eql?(:before) }.map(&:raw_filter).include?(:generate_username_confirmation_and_auth).should == true      
    end
  end

  describe :access_tokens_for_application do 
    it "returns [] if no application" do 
      user = User.new 
      user.access_tokens_for_application(nil).should eq([])
    end
    it "returns access tokens for the application" do 
      user = FactoryGirl.create(:user)
      application = Doorkeeper::Application.new(name: 'test', redirect_uri: 'https://foo.bar')
      application2 = Doorkeeper::Application.new(name: 'other_test', redirect_uri: 'https://foo.bar')
      application.owner = user
      application.save
      application2.owner = user
      application2.save
      access_token = Doorkeeper::AccessToken.create(application_id: application.id, resource_owner_id: user.id)
      access_token2 = Doorkeeper::AccessToken.create(application_id: application2.id, resource_owner_id: user.id)
      tokens = user.reload.access_tokens_for_application(application.id)
      tokens.first.should eq(access_token)
      tokens = user.reload.access_tokens_for_application(application2.id)
      tokens.first.should eq(access_token2)
    end
  end

  describe :reset_token_time do 
    it "gets long time ago if not there" do 
      user = User.new
      user.stub(:password_reset_token).and_return("c7c3b99a319ac09e2b00-2015-03-31 19:29:52 -0500")
      user.reset_token_time.should eq(Time.at(1364777722))
    end
    it "gets the time" do 
      user = User.new 
      user.set_password_reset_token
      user.reset_token_time.should be > Time.now - 2.seconds
    end
    it "uses input time" do 
      user = FactoryGirl.create(:user)
      user.set_password_reset_token((Time.now - 61.minutes).to_i)
      user.reload.reset_token_time.should be < (Time.now - 1.hours)
    end
  end

  describe :send_password_reset_email do 
    it "enqueues sending the password reset" do 
      user = FactoryGirl.create(:user)
      user.password_reset_token.should be_nil
      expect {
        user.send_password_reset_email
      }.to change(EmailResetPasswordWorker.jobs, :size).by(1)
      user.reload.password_reset_token.should_not be_nil
    end
    
    it "doesn't send another one immediately" do 
      user = FactoryGirl.create(:user)
      user.send_password_reset_email
      user.should_not_receive(:set_password_reset_token)
      user.send_password_reset_email
      expect {
        user.send_password_reset_email
      }.to change(EmailResetPasswordWorker.jobs, :size).by(0)
    end
  end

  describe :slug_username do 
    it "doesn't let you overwrite usernames" do 
      target = "coolname"
      user1 = FactoryGirl.create(:user)
      user1.update_attribute :username, target
      user1.reload.username.should eq(target)
      user2 = FactoryGirl.create(:user)
      user2.username = "#{target}'"
      user2.save.should be_false
      user2.errors.full_messages.to_s.should match('Username has already been taken')
      user2.reload.username.should_not eq(target)
      user1.reload.username.should eq(target)
    end
    it "haves before validation callback" do 
      User._validation_callbacks.select { |cb| cb.kind.eql?(:before) }.map(&:raw_filter).include?(:slug_username).should == true      
    end
  end

  describe :subscriptions do 
    it "returns the payment if payment is subscription" do 
      user = FactoryGirl.create(:user)
      payment = Payment.create(is_recurring: true, user_id: user)
      user.subscriptions.should eq(user.payments.where(is_recurring: true))
    end
  end


end
