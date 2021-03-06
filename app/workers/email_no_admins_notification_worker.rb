class EmailNoAdminsNotificationWorker
  include Sidekiq::Worker
  sidekiq_options queue: 'email'
  sidekiq_options backtrace: true

  def perform(organization_id)
    @organization = Organization.find(organization_id)
    AdminMailer.no_admins_notification_email(@organization).deliver
  end

end