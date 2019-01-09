class BotDecorator < Draper::Decorator
  delegate_all

  REFERENCE_PATHS = {
    dollcost_average_bots: 'https://ja.wikipedia.org/wiki/%E3%83%89%E3%83%AB%E3%83%BB%E3%82%B3%E3%82%B9%E3%83%88%E5%B9%B3%E5%9D%87%E6%B3%95',
    trailing_stop_bots: 'http://www.theacademy-ibt.com/'
  }.freeze

  def each_concrete_class_name
    # FIXME: STIのサブクラスが読み込まれないためのWA
    # rubocop:disable all
    DollcostAverageBot
    TrailingStopBot
    # rubocop:enable all

    object.class
          .subclasses
          .map(&:to_s)
          .map { |cc| [cc, cc.underscore.pluralize] }
          .map { |cc| [cc[0], cc[1], REFERENCE_PATHS[cc[1].to_sym]] }
          .each { |cc| yield cc[0], cc[1], cc[2] }
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

  # ユーザから与えられるBotイベントの選択一覧表示
  def status_options_for_select
    h.options_for_select(
      object.aasm
          .events(permitted: true)
          .map(&:name)
          .tap { |n| puts n }
          .reject { |n| n == :complete }
          .tap { |n| puts n }
          .map { |n| [I18n.t("activerecord.events.bot/#{n}"), n] }
    )
  end

  def thresh_levels
    Array.new(10).map { |i| Time.zone.now + object.interval * i }
  end

  def bot_type_name
    object.class.to_s.underscore.pluralize
  end
end
