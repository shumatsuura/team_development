class NotificationMailer < ApplicationMailer
  def delete_agenda(info)
    @info = info

    mail to: @info[:email], subject: "通知メール"
  end
  def change_owner_mail(team)
    @team = team

    mail to: @team.owner.email, subject: "通知メール"
  end
end
