class BotsController < ApplicationController
  before_action :validate_status_event

  def index
    @bots = current_user.bots.includes(:currency_pair).decorate
  end

  def show
    @bot = current_user.bots.find(bot_params[:id]).decorate
    @order_logs = @bot.order_logs.decorate
  end

  def edit
    @bot = current_user.bots.find(bot_params[:id]).decorate
  end

  def create
    redirect_to bot_creation_step_path(:type_selection)
  end

  def update
    @bot = current_user.bots.find(bot_params[:id])
    @bot.send(params[:status_event])
    @bot.save!
    redirect_to bots_path, notice: 'Botを更新しました'
  end

  def destroy
    @bot = current_user.bots.find(bot_params[:id])
    @bot.destroy
    redirect_to bots_path, notice: 'Botを削除しました'
  end

  private

  def bot_params
    #  TODO: ストロングパラメータ実装
    params.permit!
    # params.require(:bot).permit(:content)
  end

  def validate_status_event
    return if params[:status_event].nil?
    return if %w[resume complete pend].include?(params[:status_event])

    raise 'Illegal event received'
  end
end
