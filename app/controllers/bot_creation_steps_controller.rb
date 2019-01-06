class BotCreationStepsController < ApplicationController
  include Wicked::Wizard

  steps :type_selection, :parameter_input, :confirmation, :creation

  def show
    case step
    when :parameter_input, :confirmation
      @bot = Bot.make(params)
    when :creation
      @bot = Bot.make(params)
      @bot.save!
      redirect_to bots_path
    end
    render_wizard @bot
  end

  def update
    render_wizard @bot
  end

  private

  def finish_wizard_path
    bots_path
  end
end
