class BotDecorator < Draper::Decorator
  delegate_all

  def each_concrete_class_name
    # FIXME: STIのサブクラスが読み込まれないためのWA
    # rubocop:disable all
    DollcostAverageBot
    TrailingStopBot
    # rubocop:enable all

    object.class
          .subclasses
          .map(&:to_s)
          .map { |cc| { value: cc, dictionay_name: cc.underscore.pluralize } }
          .each { |cc| yield cc }
  end

  def introduction
    I18n.t("#{bot_type_name}.introduction")
  end

  def status
    case object.status
    when 'running' then '稼働中'
    when 'pending' then '停止中'
    when 'completed' then '動作完了'
    end
  end

  def created_at
    I18n.l(object.created_at, format: :long)
  end

  def strategy
    I18n.t("#{bot_type_name}.strategy")
  end

  def render_parameter_form
    h.render "bot_decorator/#{bot_type_name}/parameter_form", bot: self
  end

  def render_detail
    h.render "bot_decorator/#{bot_type_name}/detail", bot: self
  end

  def render_confirmation
    h.render "bot_decorator/#{bot_type_name}/confirmation", bot: self
  end

  def description
    case object
    when DollcostAverageBot
      I18n.t(
        'dollcost_average_bots.description',
        interval: interval,
        key: currency_pair.key_currency,
        amount: dca_settlment_amount
      )
    when TrailingStopBot
      I18n.t(
        'trailing_stop_bots.description',
        pair: currency_pair.name,
        amount: ts_key_amount
      )
    else
      raise "Unsupported class #{object.class}"
    end
  end

  def interval
    format(
      '%<value>d %<unit>s',
      value: object.dca_interval_value,
      unit: I18n.t("dollcost_average_bots.#{object.dca_interval_unit}")
    )
  end

  def interval_units_for_select
    h.options_for_select(
      Bot.dca_interval_units.keys.map { |iu| [I18n.t("dollcost_average_bots.#{iu}"), iu] }
    )
  end

  def thresh_levels
    Array.new(10).map { |i| Time.zone.now + object.interval * i }
  end

  def bot_type_name
    object.class.to_s.underscore.pluralize
  end
end
