module GlobalViewHelper
  def display_currency(number)
    sprintf("%01.2f €", number) unless number.nil?
  end 
end
