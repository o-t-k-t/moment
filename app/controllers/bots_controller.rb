class BotsController < ApplicationController
  def index
    @bots = current_user.bots
  end

  def show
    @bot = current_user.bots.find(bot_params[:id])
  end

  def edit
    @bot = current_user.bots.find(bot_params[:id])
  end

  def create
    redirect_to bot_creation_step_path(:type_selection)
  end

  def update
    @bot = current_user.bots.find(bot_params[:id])
    if @bot.update(bot_params)
      redirect_to tweets_path, notice: 'Botを更新しました'
    else
      render 'edit'
    end
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
end
