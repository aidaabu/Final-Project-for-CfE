cd "C:\Users\Abuova_Aida\Desktop\CfE Final Project"
clear all
set more off, perm
capture log close
log using "main.log", replace text

*importing the dataset to the stata first
import delimited "airbnb_london_listing.csv", clear

*creating separate folders 
cap mkdir data
cap mkdir output
cap mkdir output/graphs
cap mkdir output/tables
cap mkdir temp

*I am dropping missing values in one selected variable as part of fixing data quality errors
drop if missing(review_scores_value)

*Now it is converting string variables into numeric variables. As a result, we have less observartions and variables in red
destring review_scores_location review_scores_communication host_listings_count review_scores_value reviews_per_month host_response_rate host_total_listings_count bathrooms bedrooms beds review_scores_checkin review_scores_rating review_scores_accuracy review_scores_cleanliness, replace force

*creating a new numeric variable out of existing string variable assigning the values of 1 to "t" and 0 to "f". I didn't take every string variable for this, only few. 
gen host_is_superhost_numeric = (host_is_superhost == "t")
gen host_has_profile_pic_numeric = ( host_has_profile_pic == "t")
gen host_identity_verified_numeric = ( host_identity_verified == "t")
gen is_location_exact_numeric = ( is_location_exact == "t")
gen require_guest_profilenumeric = ( require_guest_profile_picture == "t")
gen require_guest_phone_vernumeric = ( require_guest_phone_verification == "t")

*creating summary statistics of our numeric variables
sum host_response_rate  review_scores_value guests_included  latitude bathrooms availability_30 availability_365 review_scores_cleanliness review_scores_accuracy review_scores_communication calculated_host_listings_count host_listings_count availability_90 longitude     bedrooms   minimum_nights  availability_60 number_of_reviews reviews_per_month   accommodates  beds     host_total_listings_count    maximum_nights   review_scores_rating review_scores_checkin review_scores_location

*installing a package to create a summary statistics table
ssc install estout

*creating a summary statistics table
estpost summarize host_response_rate guests_included  latitude bathrooms availability_30 availability_365  review_scores_accuracy review_scores_communication calculated_host_listings_count host_listings_count longitude     bedrooms   minimum_nights  availability_60 number_of_reviews review_scores_cleanliness review_scores_location reviews_per_month   accommodates  beds     host_total_listings_count    maximum_nights  availability_90  review_scores_rating review_scores_checkin review_scores_value

*downloading and transfering a summary statistics table to a folder
esttab using "output/summary_statistics1.txt", cells("count mean sd min max") replace

*creating a histogram and exporting it from stata to "Graphs" folder
hist availability_365
hist availability_365, title ("Availability")
graph export "output/graphs/Histogram.png", replace

*creating an additional bar graph and exporting it
graph bar (mean) bathrooms (mean) bedrooms (mean) beds 
graph export "C:\Users\Abuova_Aida\Desktop\CfE Final Project\output\graphs/Bar Graph.png", as(png) name("Graph")

*created a copy of the original variable 'bathrooms' and then filtered its observations by number of bathrooms
gen bathrooms_copy = bathrooms
keep if bathrooms_copy >= 2

*filtered the variables
keep host_response_rate guests_included  latitude bathrooms availability_30 availability_365  review_scores_accuracy  maximum_nights  availability_90 review_scores_communication  review_scores_checkin host_listings_count longitude   accommodates  beds   bedrooms   minimum_nights  availability_60 number_of_reviews review_scores_cleanliness review_scores_location reviews_per_month      host_total_listings_count  calculated_host_listings_count  review_scores_rating review_scores_value bathrooms_copy

*creating a transformation of variables - transforming them into categories by assigning them the values of 1 is "low number of bathrooms", 2 is "medium number of bathrooms", and 3 is "high number of bathrooms" - categorical transformation (one of the types)
generate bathrooms_copy_category = .
replace bathrooms_copy_category = 1 if beds >=2 & beds < 4
replace bathrooms_copy_category = 2 if beds >=4 & beds < 6
replace bathrooms_copy_category = 3 if beds >= 6