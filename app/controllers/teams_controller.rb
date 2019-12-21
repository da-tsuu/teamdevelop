class TeamsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_team, only: %i[show edit update destroy, change_team_owner]

  def index
    @teams = Team.all
  end

  def show
    @working_team = @team
    change_keep_team(current_user, @team)
  end

  def new
    @team = Team.new
  end

  def edit; end

  def create
    @team = Team.new(team_params)
    @team.owner = current_user
    if @team.save
      @team.invite_member(@team.owner)
      redirect_to @team, notice: I18n.t('views.messages.create_team')
    else
      flash.now[:error] = I18n.t('views.messages.failed_to_save_team')
      render :new
    end
  end

  def update
    if @team.update(team_params)
      redirect_to @team, notice: I18n.t('views.messages.update_team')
    else
      flash.now[:error] = I18n.t('views.messages.failed_to_save_team')
      render :edit
    end
  end

  def destroy
    if @team.update(team_params)
      redirect_to @team, notice: I18n.t('views.messages.update_team')#チーム更新に成功しました
    else
      flash.now[:error] = I18n.t('views.messages.failed_to_save_team')#保存に失敗しました
      render :edit
    end
  end

  def dashboard
    @team = current_user.keep_team_id ? Team.find(current_user.keep_team_id) : current_user.teams.first
  end

  def change_team_owner
    if @team.owner.id == current_user.id
      @user = User.find(params[:select_user])
      @team.update(owner_id: @user.id)
      NewOwnerMailer.new_owner_mail(@user.email, @team.name).deliver
      redirect_to @team, notice: 'チームのオーナー権限を与えられました'
    else
      redirect_to @team, notice: '権限を与えられませんでした'
    end
  end

  private

  def set_team
    @team = Team.friendly.find(params[:id])
  end

  def team_params
    params.fetch(:team, {}).permit %i[name icon icon_cache owner_id keep_team_id]
  end
end
