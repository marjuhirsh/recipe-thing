
class Recipe

  attr_accessor :name, :servings, :preparation_time, :ingredients

  def initialize(name, servings, preparation_time, ingredients)
    @name = name
    @servings = servings
    @preparation_time = preparation_time
    @ingredients = ingredients
  end

  def recipe_price(ingredients = @ingredients)

    ingredient_price_in_recipe = 0
    total = 0

    ingredients.each do |key, value|
      ingredient_price_in_recipe = value.to_f / 1000 * key.price_per_plokg
      total = (total + ingredient_price_in_recipe).round(2)
    end

    total

  end

  def recipe_ingredient_prices(ingredients = @ingredients, name = @name)

    ingredient_price_in_recipe = 0
    puts name + ":"

    ingredients.each do |key, value|
      ingredient_price_in_recipe = (value.to_f / 1000 * key.price_per_plokg).round(2)
      puts "#{key.name} selles retseptis kokku: #{ingredient_price_in_recipe} eurot"
    end

    puts " "

  end

  def recipe_kcal(ingredients = @ingredients)

    ingredient_kcal_in_recipe = 0
    total = 0

    ingredients.each do |key, value|
      ingredient_kcal_in_recipe = value.to_f * ((key.kcal_per_100g).to_f / 100)
      total = (total + ingredient_kcal_in_recipe).round(0)
    end

    total

  end

  def recipe_ingredient_kcals(ingredients = @ingredients, name = @name)

    ingredient_kcal_in_recipe = 0
    puts name + ":"

    ingredients.each do |key, value|
      ingredient_kcal_in_recipe = value.to_f * ((key.kcal_per_100g).to_f / 100)
      puts "#{key.name} selles retseptis kokku: #{ingredient_kcal_in_recipe.round(0)} kcal"
    end

    puts " "

  end

end


class Ingredient

  attr_reader :name, :price_per_plokg, :kcal_per_100g

  def initialize(name, price_per_plokg, kcal_per_100g = 0)
    @name = name
    @price_per_plokg = price_per_plokg
    @kcal_per_100g = kcal_per_100g
  end

  def quantified_ingredient_price(quantity)
    (quantity.to_f / 1000 * price_per_plokg).round(2)
  end

end
