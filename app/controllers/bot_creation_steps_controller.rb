class BotCreationStepsController < ApplicationController
  include Wicked::Wizard

  steps :type_selection, :parameter_input, :confirmation, :creation

  def show
    case step
    when :type_selection
      @bot = Bot.new.decorate
      @currency_pairs = CurrencyPair.all
    end
    render_wizard @bot
  end

  def update
    @bot = Bot.make(bot_params)&.decorate

    case step
    when :parameter_input
      unless @bot
        flash[:notice] = I18n.t('bots.selection_fail')
        redirect_to previous_wizard_path
        return
      end
    when :confirmation
      unless @bot&.valid?
        flash[:notice] = I18n.t('bots.confirmation_fail')
        redirect_to wizard_path(:type_selection)
        return
      end
    when :creation
      @bot.save!
      flash[:notice] = I18n.t('bots.creation_success')
      redirect_to bots_path
      return
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
      :ts_key_amount
    )
  end

  def finish_wizard_path
    bots_path
  end
end
