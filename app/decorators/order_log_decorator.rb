class OrderLogDecorator < Draper::Decorator
  delegate_all

  def created_at
    I18n.l(object.created_at, format: :long)
  end
end
