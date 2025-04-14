# frozen_string_literal: true

class ApplicationMailer < ActionMailer::Base
  default from: 'no-reply@stepangolovko.tech'
  layout 'mailer'
end
