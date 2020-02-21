class NotificationMailer < ApplicationMailer
  def delete_agenda(info)
    @info = info

    mail to: @info[:email], subject: "通知メール"
  end
end
