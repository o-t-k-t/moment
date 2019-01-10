class BotCreationStepsController < ApplicationController
  include Wicked::Wizard

  steps :type_selection, :parameter_input, :confirmation, :creation

  def show
    case step
    when :type_selection
      @bot = Bot.new.decorate
      @currency_pairs = CurrencyPair.all
    when :parameter_input
      @bot = Bot.make(takeover_bot_params)&.decorate
      @bot.user = current_user
      @currency_pairs = CurrencyPair.all
      @bot.valid?
    else
      redirect_to bots_path and return
    end

    render_wizard
  end

  def update # rubocop:disable Metrics/CyclomaticComplexity, Metrics/MethodLength
    @bot = Bot.make(bot_params)&.decorate
    @currency_pairs = CurrencyPair.all

    case step
    when :parameter_input
      unless @bot
        flash[:notice] = I18n.t('bots.selection_fail')
        redirect_to wizard_path(:type_selection) and return
      end
    when :confirmation
      @bot.user = current_user
      if @bot.invalid?
        jump_to(:parameter_input, takeover_params: bot_params)
        # render :parameter_input and return
      end
    when :creation
      @bot.user = current_user
      @bot.save!
      flash[:notice] = I18n.t('bots.creation_success')
      redirect_to bots_path and return
    else
      raise 'Undefined wizard page'
    end
    render_wizard
  end

  private

  def bot_params
    params.require(:bot).permit(
      :type,
      :currency_pair_id,
      :level_base,
      :level_slope,
      :dca_settlment_amount,
      :dca_interval_unit,
      :dca_interval_value,
      :ts_key_amount
    )
  end

  def takeover_bot_params
    params.require(:takeover_params)&.permit(
      :type,
      :currency_pair_id,
      :level_base,
      :level_slope,
      :dca_settlment_amount,
      :dca_interval_unit,
      :dca_interval_value,
      :ts_key_amount
    )
  end


  def finish_wizard_path
    bots_path
  end
end
