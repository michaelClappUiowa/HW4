# Completed step definitions for basic features: AddMovie, ViewDetails, EditMovie 

Given /^I am on the RottenPotatoes home page$/ do
  visit movies_path
 end


 When /^I have added a movie with title "(.*?)" and rating "(.*?)"$/ do |title, rating|
  visit new_movie_path
  fill_in 'Title', :with => title
  select rating, :from => 'Rating'
  click_button 'Save Changes'
 end

 Then /^I should see a movie list entry with title "(.*?)" and rating "(.*?)"$/ do |title, rating| 
   result=false
   all("tr").each do |tr|
     if tr.has_content?(title) && tr.has_content?(rating)
       result = true
       break
     end
   end  
   assert result
 end

 When /^I have visited the Details about "(.*?)" page$/ do |title|
   visit movies_path
   click_on "More about #{title}"
 end

Then /^(?:|I )should see "([^"]*)"$/ do |text|
  if page.respond_to? :should
    expect(page).to have_content(text)
  else
    assert page.has_content?(text)
  end
end

 When /^I have edited the movie "(.*?)" to change the rating to "(.*?)"$/ do |movie, rating|
  click_on "Edit"
  select rating, :from => 'Rating'
  click_button 'Update Movie Info'
 end


# New step definitions to be completed for HW3. 
# Note that you may need to add additional step definitions beyond these


# Add a declarative step here for populating the DB with movies.

Given /the following movies have been added to RottenPotatoes:/ do |movies_table|
  movies_table.hashes.each do |movie|
	Movie.create(rating: movie['rating'], title: movie['title'], release_date: movie['release_date'])
  end
end

When /^I have opted to see movies rated: "(.*?)"$/ do |arg1|
	allRating = ["G","R","PG-13","PG"]	
	rating = arg1.delete(" ").split(",")
	notrating = allRating - rating
	rating.each do |r|
		check("ratings_#{r}")
	end
	notrating.each do |r|
		uncheck("ratings_#{r}")
	end
	click_button "ratings_submit"
	# HINT: use String#split to split up the rating_list, then
  # iterate over the ratings and check/uncheck the ratings
  # using the appropriate Capybara command(s)
end

Then /^I should see only movies rated "(.*?)"$/ do |arg1|
  	result=true
	allRating = ["G","R","PG-13","PG"]	
	rating = arg1.delete(" ").split(",")
	notrating = allRating - rating
	Movie.all.each do |movie|
		if notrating.include?(movie.rating)
			if page.has_content?(movie.title)
				result = false
  				break
 			end
		else
			if not page.has_content?(movie.title)
				result = false
				break
			end			
		end   
	end     
assert result 
end

Then /^I should see all of the movies$/ do
	val = Movie.count
	val +=1
	all("tr").count.should == val
end

When /^I have opted to sort alphabetically$/ do
	click_on "Movie Title"
end

Then(/^I should see "(.*?)" before "(.*?)"$/) do |arg1, arg2|
  	result = true
	if (page.body =~ /#{arg1}/) > (page.body =~ /#{arg2}/)
		result = false
	end
assert result
end

When /^I have opted to sort by date$/ do
	click_on "Release Date"
end





