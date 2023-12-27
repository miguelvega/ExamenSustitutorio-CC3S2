
Given /the following movies exist/ do |movies_table|
  movies_table.hashes.each do |movie|
    Movie.create movie
  end
end

Then /I should see "(.*)" before "(.*)"/ do |e1, e2|
  # ensure that that e1 occurs before e2.
  # page.body is the entire content of the page as a string.
  expect(page.body.index(e1) < page.body.index(e2))
end

When /I (un)?check the following ratings: (.*)/ do |uncheck, rating_list|
  rating_list.split(', ').each do |rating|
    step %{I #{uncheck.nil? ? '' : 'un'}check "ratings_#{rating}"}
  end
end

Then /I should see all the movies/ do
  # Make sure that all the movies in the app are visible in the table
  Movie.all.each do |movie|
    step %{I should see "#{movie.title}"}
  end
end

Then(/^the director of "([^"]*)" should be "([^"]*)"$/) do |movie_title, director_name|
  movie = Movie.find_by(title: movie_title)
  expect(movie.director).to eq(director_name)
end


Then("I should see the list of movies") do
  # Implement the steps to verify that the list of movies is displayed
  expect(page).to have_content("Star Wars")
  expect(page).to have_content("Blade Runner")
  # Add more expectations as needed
end


Then("I should see the list of movies on the home page") do
  expect(page).to have_content("Star Wars")
  expect(page).to have_content("Blade Runner")
end





