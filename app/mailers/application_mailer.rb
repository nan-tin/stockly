class ApplicationMailer < ActionMailer::Base
  default from: ENV.fetch(
    "MAILER_FROM",
    "Stockly <onboarding@resend.dev>"
  )

  layout "mailer"
end