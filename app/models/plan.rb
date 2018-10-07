class Plan
  # constant variable
  PLANS = [:free, :premuim]

  def self.options
    # map method basically modify each element in array
    PLANS.map { |plan| [plan.capitalize, plan] }
  end
end