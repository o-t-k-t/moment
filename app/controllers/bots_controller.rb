class BotsController < ApplicationController
  decorates_assigned :bot

  def index
    @bots = current_user.bots.includes(:currency_pair).decorate
  end

  def show
    @bot = current_user.bots.find(params[:id])
  end

  def edit
    @bot = current_user.bots.find(params[:id])
  end

  def create
    redirect_to bot_creation_step_path(:type_selection)
  end

  def update
    @bot = current_user.bots.find(params[:id])
    @bot.send(status_event_param)
    @bot.save!
    redirect_to bots_path, notice: 'Botを更新しました'
  end

  def destroy
    @bot = current_user.bots.find(params[:id])
    @bot.destroy
    redirect_to bots_path, notice: 'Botを削除しました'
  end

  private

  def status_event_param
    return nil if params[:status_event].nil?
    raise 'Illegal event received' if %w[resume pend].exclude?(params[:status_event])

    params[:status_event]
  end
end
