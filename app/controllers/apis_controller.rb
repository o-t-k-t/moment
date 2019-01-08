class ApisController < ApplicationController
  def edit
    @user = User.new
  end

  def update
    if current_user.update_attributes(api_key: params[:api_key], secret_key: params[:secret_key])
      redirect_to bots_path, notice: 'APIキーが登録されました'
    else
      render :edit
    end
  end
end
