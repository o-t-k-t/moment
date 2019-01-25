class ApisController < ApplicationController
  def edit
    @user = current_user
  end

  def update
    @user = current_user

    if @user.update(api_params)
      redirect_to bots_path, notice: 'APIキーが登録されました'
    else
      render :edit
    end
  end

  private

  def api_params
    params.require(:user).permit(:api_key, :secret_key)
  end
end
