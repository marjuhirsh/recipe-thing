require_relative 'instantiation.rb'
require 'colorize'
require 'pry'

all_recipe_names = []
$all_recipes.each do |recipe|
  all_recipe_names.push(recipe.name)
end

all_ingredient_names = []
$all_ingredients.each do |ingredient|
  all_ingredient_names.push(ingredient.name)
end

$ingredients_to_add = []
$recipes_to_add = []
$ingredient_quantities = []
$display_to_add = []

def input_is_numeric?(input)
  if input == ''
    return false
  end
  binding.pry
  input.to_i.to_s == input # returns true if input contains only digits
end

def current_add_list()
  $display_to_add.each do |element|
    puts(element)
  end
end

def calculate()
  ingredients_total = 0
  recipes_total = 0

  $ingredients_to_add.each_with_index do |ingredient, index|
    ingredients_total += ingredient.quantified_ingredient_price($ingredient_quantities[index])
  end

  $recipes_to_add.each do |recipe|
    recipes_total += recipe.recipe_price
  end

  (ingredients_total + recipes_total).round(2)

end

puts("")
puts("All known ingredients: ".colorize(:green))
all_ingredient_names.each do |ingredient_name|
  puts(ingredient_name)
end

puts("")
puts("All known recipes: ".colorize(:green))
all_recipe_names.each do |recipe_name|
  puts(recipe_name)
end

loop = true

while loop == true do
  included_in_recipes = false
  included_in_ingredients = false
  reset_entered = false
  calculate_entered = false
  delete_entered = false
  quantity_entered = false
  quantity_is_numeric = false
  multi_match_selector_entered = false
  multi_match_selector_is_numeric = false
  all_scanned = false
  $ingredient_matches = []
  puts("")
  puts("Enter code of recipe (e.g., 'E1') or name of ingredient to add to price calculation, \nor press Enter to select ingredient by number.\n\nEnter '=' to calculate price of added ingredients.\nEnter 'reset' to reset add list.\nEnter 'delete' to delete last element from list.".colorize(:cyan))
  input = gets.chomp.downcase.force_encoding(::Encoding::UTF_8)

  if input == "reset"
    reset_entered = true
    $ingredients_to_add = []
    $recipes_to_add = []
    $ingredient_quantities = []
    $display_to_add = []
    puts("")
    puts("Element add list has been reset.".colorize(:green))
  end

  if input == "="
    calculate_entered = true
    puts("")
    puts("Total price of added ingredients: #{calculate()} euros".colorize(:green))
  end

  if input == "delete"
    delete_entered = true
    puts("")
    puts("Last element (#{$display_to_add[$display_to_add.length - 1]}) deleted from list.".colorize(:green))
    if ($display_to_add[$display_to_add.length - 1].include?("1") || $display_to_add[$display_to_add.length - 1].include?("2") || $display_to_add[$display_to_add.length - 1].include?("3") || $display_to_add[$display_to_add.length - 1].include?("4"))
      $recipes_to_add.pop
    else
      $ingredients_to_add.pop
      $ingredient_quantities.pop
    end
    $display_to_add.pop
    puts("Current element add list: ".colorize(:green))
    current_add_list()
  end

  if reset_entered == false && calculate_entered == false && delete_entered == false
    $all_recipes.each do |recipe|
      if (input.include?("1") || input.include?("2") || input.include?("3") || input.include?("4")) && recipe.name.downcase.include?(input)
        $recipes_to_add.push(recipe)
        $display_to_add.push(recipe.name)
        puts("")
        puts("Match found: '#{recipe.name}' in recipes. Added to calculation.".colorize(:green))
        puts("Current element add list: ".colorize(:green))
        current_add_list()
        included_in_recipes = true
      end
    end
  end

  if reset_entered == false && calculate_entered == false && delete_entered == false && included_in_recipes == false
    puts("")
    puts("Element not found in recipes. Scanning ingredients.".colorize(:cyan))
    match_scan_counter = 0
    $all_ingredients.each do |ingredient|

      match_scan_counter += 1
      if ingredient.name.downcase.include?(input) && all_scanned == false && input != " "
        $ingredient_matches.push(ingredient)
      end
      if match_scan_counter == $all_ingredients.length
        all_scanned = true
        puts("All ingredients scanned.".colorize(:cyan))
      end

      if ingredient.name.downcase == input && included_in_ingredients == false
        $ingredients_to_add.push(ingredient)
        $display_to_add.push(ingredient.name)
        puts("")
        puts("Exact match found: '#{ingredient.name}'. Added to calculation.".colorize(:green))
        included_in_ingredients = true
      end

      if $ingredient_matches.length == 1 && included_in_ingredients == false && all_scanned == true
        $ingredients_to_add.push($ingredient_matches[0])
        $display_to_add.push($ingredient_matches[0].name)
        puts("")
        puts("One rough match found: '#{$ingredient_matches[0].name}'. Added to calculation.".colorize(:green))
        included_in_ingredients = true
      end

      if $ingredient_matches.length > 1 && included_in_ingredients == false && all_scanned == true
        puts("")
        puts("Multiple rough matches found: ".colorize(:green))
        $ingredient_matches.each_with_index do |match, index|
          puts((index + 1).to_s + ": " + $ingredient_matches[index].name)
        end
        if multi_match_selector_entered == false
          while multi_match_selector_is_numeric == false
            puts("")
            puts("Please enter number to select ingredient.".colorize(:cyan))
            multi_match_selector = gets.chomp
            if input_is_numeric?(multi_match_selector) == true && (1..$ingredient_matches.length) === multi_match_selector.to_i
              multi_match_selector_entered = true
              multi_match_selector_is_numeric = true
              $ingredients_to_add.push($ingredient_matches[multi_match_selector.to_i - 1])
              $display_to_add.push($ingredient_matches[multi_match_selector.to_i - 1].name)
              puts("")
              puts("Ingredient selected: '#{$ingredient_matches[multi_match_selector.to_i - 1].name}'. Added to calculation.".colorize(:green))
              included_in_ingredients = true
            else
              multi_match_selector_entered = true
              puts("")
              puts("Invalid number entered. Please try again.".colorize(:red))
            end
          end
        end
      end

      if included_in_ingredients == true && quantity_entered == false
        while quantity_is_numeric == false
          puts("")
          puts("Enter ingredient quantity in grams. E.g., '100' for 100 grams.".colorize(:cyan))
          quantity = gets.chomp
          if input_is_numeric?(quantity) == true
            quantity_entered = true
            quantity_is_numeric = true
            quantity = quantity.to_i
            $ingredient_quantities.push(quantity)
            $display_to_add[$display_to_add.length - 1] += " (#{$ingredient_quantities[$ingredient_quantities.length - 1]})"
            puts("")
            puts("Current element add list: ".colorize(:green))
            current_add_list()
          else
            quantity_entered = true
            puts("")
            puts("Invalid number entered. Please try again.".colorize(:red))
          end
        end
      end
    end
  end

  if reset_entered == false && calculate_entered == false && delete_entered == false && included_in_recipes == false && included_in_ingredients == false
    puts("")
    puts("Invalid command, or element not found. Please try again.".colorize(:red))
  end
end
