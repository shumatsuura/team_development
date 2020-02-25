class AgendasController < ApplicationController
  # before_action :set_agenda, only: %i[show edit update destroy]

  def index
    @agendas = Agenda.all
  end

  def new
    @team = Team.friendly.find(params[:team_id])
    @agenda = Agenda.new
  end

  def create
    @agenda = current_user.agendas.build(title: params[:title])
    @agenda.team = Team.friendly.find(params[:team_id])
    current_user.keep_team_id = @agenda.team.id
    if current_user.save && @agenda.save
      redirect_to dashboard_url, notice: I18n.t('views.messages.create_agenda')
    else
      render :new
    end
  end

  def destroy
    @agenda = Agenda.find(params[:id])
    if (current_user == @agenda.user) || (current_user == @agenda.team.owner)
      if @agenda.destroy
          redirect_to dashboard_path, notice: "削除しました。"
          @agenda.team.members.each do |member|
            @info = {title: @agenda.title, email: member.email}
            NotificationMailer.delete_agenda(@info).deliver
          end
      else
        render 'dashboard'
      end
    else
      redirect_to dashboard_path, notice: '権限がありません。'
    end
  end

  private

  def set_agenda
    @agenda = Agenda.find(params[:id])
  end

  def agenda_params
    params.fetch(:agenda, {}).permit %i[title description]
  end
end
