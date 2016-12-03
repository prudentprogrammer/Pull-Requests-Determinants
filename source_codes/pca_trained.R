
train <- read.csv(file="preprocessed_data_v4.csv", head=TRUE, sep=",")
#test <- read.csv(file="~/UC Davis/Quarters/2016-17/Fall 2016/ECS 260/Project/preprocessed_data_v4_test.csv", head=TRUE, sep=","")

#add a columns to test
#test$Merged <- 1


#Next 3 paragraphs are dedicated to imputing missing values. Not necessary for our code.

# combi <- rbind(train, test)
#Input missing values w/ median Note: No Missing item
#combi$Item_Weight[is.na(combi$Item_Weight)] <- median(combi$Item_Weight, na.rm = TRUE)

# impute 0 w/ median 
#combi$Item_Visibility <- ifelse(combi$Item_Visibility == 0, median(combi$Item_Visibility), combi$Item_Visibility)

#find mode and impute 
#table(combi$Outlet_Size, combi$Outlet_Type)
#levels(combi$Outlet_Size)[1] <- "Other"


prin_comp <- prcomp(train, scale. = T)
names(prin_comp)
prin_comp$center
prin_comp$scale
summary(prin_comp)

dim(prin_comp$x)
biplot(prin_comp, scale = 0)

std_dev <- prin_comp$sdev
pr_var <- std_dev^2
prop_varex <- pr_var/sum(pr_var)

#scree plot
#plot(prop_varex, xlab = "Principal Component", ylab = "Proportion of Variance", type = "b")

#Cumulative Scree Plot
#plot(cumsum(prop_varex), xlab = "Principal Component", ylab = "Cumulative Proportion of Variance Explained", type = "b") 
