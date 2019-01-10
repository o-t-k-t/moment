class BotCreationStepsController < ApplicationController
  include Wicked::Wizard

  steps :type_selection, :parameter_input, :confirmation, :creation

  def show
    @currency_pairs = CurrencyPair.all

    case step
    when :type_selection
      @bot = current_user.bots.build.decorate
    when :parameter_input
      @bot = current_user.bots.build(takeover_bot_params).decorate
      @bot.valid?
    else
      redirect_to bots_path and return
    end

    render_wizard
  end

  def update # rubocop:disable Metrics/CyclomaticComplexity
    @bot = current_user.bots.build(bot_params).decorate
    @currency_pairs = CurrencyPair.all

    case step
    when :parameter_input
      unless @bot.inherited_bot? && @bot.currency_pair
        flash[:notice] = I18n.t('bots.selection_fail')
        redirect_to wizard_path(:type_selection) and return
      end
    when :confirmation
      jump_to(:parameter_input, takeover_params: bot_params) if @bot.invalid?
    when :creation
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
end
