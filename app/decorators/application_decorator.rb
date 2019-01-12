class ApplicationDecorator < Draper::Decorator
  def created_at
    I18n.l(object.created_at, format: :long)
  end
end
