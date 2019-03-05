class BotDecorator < ApplicationDecorator
  delegate_all
  decorates_association :order_logs
  decorates_association :currency_pair

  REFERENCE_PATHS = {
    dollar_cost_average_bots: 'https://ja.wikipedia.org/wiki/%E3%83%89%E3%83%AB%E3%83%BB%E3%82%B3%E3%82%B9%E3%83%88%E5%B9%B3%E5%9D%87%E6%B3%95',
    trailing_stop_bots: 'http://www.theacademy-ibt.com/'
  }.freeze

  def each_concrete_class_name
    # FIXME: STIのサブクラスが読み込まれないためのWA
    # rubocop:disable all
    DollarCostAverageBot
    TrailingStopBot
    # rubocop:enable all

    object.class
          .subclasses
          .map(&:to_s)
          .map { |cc| [cc, cc.underscore.pluralize] }
          .map { |cc| [cc[0], cc[1], REFERENCE_PATHS[cc[1].to_sym]] }
          .each { |cc| yield cc[0], cc[1], cc[2] }
  end

  # STI具象クラス別のI18n参照メソッドの定義
  %i[introduction strategy].each do |w|
    define_method(w) { I18n.t("#{bot_type_name}.#{w}") }
  end

  # STI具象クラス別の部分テンプレートレンダーメソッド定義
  %i[parameter_form detail confirmation].each do |p|
    define_method("render_#{p}") { h.render "bot_decorator/#{bot_type_name}/#{p}", bot: self }
  end

  def description
    case object
    when DollarCostAverageBot
      I18n.t(
        'dollar_cost_average_bots.description',
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
      unit: I18n.t("dollar_cost_average_bots.#{object.dca_interval_unit}")
    )
  end

  def interval_units_for_select
    h.options_for_select(
      Bot.dca_interval_units.keys.map { |iu| [I18n.t("dollar_cost_average_bots.#{iu}"), iu] }
    )
  end

  # 状態関連
  def status
    I18n.t("activerecord.status.#{object.status}")
  end

  # ユーザから与えられるBotイベントの選択一覧表示
  def status_options_for_select
    h.options_for_select(
      object.aasm
          .events(permitted: true)
          .map(&:name)
          .reject { |n| n == :complete }
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
