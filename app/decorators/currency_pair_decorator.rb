class CurrencyPairDecorator < ApplicationDecorator
  delegate_all

  %i[name key_currency settlement_currency].each do |w|
    define_method(w) { object.send(w).upcase.delete('_') }
  end
end
