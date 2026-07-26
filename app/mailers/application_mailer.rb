class ApplicationMailer < ActionMailer::Base
  default from: ENV.fetch(
    "MAIL_FROM",
    "Stockly <onboarding@resend.dev>"
  )

  layout "mailer"
end