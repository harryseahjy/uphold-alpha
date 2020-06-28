# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
require 'open-uri'
require 'json'
url = "https://www.thecocktaildb.com/api/json/v1/1/random.php"

18.times do
    data = JSON.parse(open(url).read)
    # Dose must have ingredient and cocktail to exist
    cocktail = Cocktail.new(name: data['drinks'][0]['strDrink'])

    # get str'ingredients' with values -- compact
    i_keys = [data['drinks'][0].to_s.scan(/"strIngredient[0-9]{1,2}"/)][0]
    ingredients = i_keys.map { |i| data['drinks'][0]["#{/[\w\d]+/.match(i)}"] }.compact
    ingredients = ingredients.map { |i| Ingredient.create(name: i) }
    # Get dose descriptions
    d_keys = [data['drinks'][0].to_s.scan(/"strMeasure[0-9]{1,2}"/)][0]
    doses = d_keys.map { |i| data['drinks'][0]["#{/[\w\d]+/.match(i)}"] }.compact
    doses = doses.map { |i| Dose.new(description: i) }

    doses.zip(ingredients).each do |a|
        a[0].ingredient = a[1]
        a[0].cocktail = cocktail
        a[0].save
    end

    p ingredients
end



