require 'spec_helper'

describe Feedback do

  describe :validations do
    it { should validate_presence_of :body }
    it { should validate_presence_of :email }
    it { should validate_presence_of :title }
    it { should serialize :feedback_hash }
    # it { should belong_to :application } # This is Doorkeeper::Application, not application
  end

  describe :create do
    it "enqueues an email job" do
      expect {
        FactoryGirl.create(:feedback)
      }.to change(EmailFeedbackNotificationWorker.jobs, :size).by(1)
    end
  end
end
