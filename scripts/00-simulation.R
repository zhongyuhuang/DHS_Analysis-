
# We will simulate data that we might find in the “Median age at first birth” table on
# page 44 of the Philippines DHS final report in 1998.

#set seed  
set.seed(100270)

number_of_observations <- 5

#simulate the data
simulated_data <- 
  data.frame(
    background=rep(letters[1:5], each = 1 ),
    percentage_who_are_mothers=runif(n=5, min=0, max=1),
    percentage_who_begun_childbearing=runif(n=5, min=0, max=1),
    percentage_who_are_pregnant=runif(n=5, min=0, max=1)
    
  )

# print the simulated data
simulated_data
