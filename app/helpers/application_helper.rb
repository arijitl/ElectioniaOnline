module ApplicationHelper
  def secular value
    value ? "Secular" : "Communal"
  end

  def young value
    value ? "Young" : "Aged"
  end

  def experienced value
    value ? "Veteran" : "Rookie"
  end

  def clean value
    value ? "Clean" : "Corrupt"
  end

  def eminent value
    value ? "Eminent" : "Uneducated"
  end

  def astute value
    value ? "Astute Administrator" : "Blindly Populist"
  end
end
