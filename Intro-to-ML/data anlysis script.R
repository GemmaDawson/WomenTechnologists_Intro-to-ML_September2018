library(pacman)
p_load(tidyverse)
p_load(tree)

titanic <- read_csv(file = "data/titanic.csv", col_names = TRUE)

head(titanic)
colnames(titanic)

glimpse(titanic)

# "PassengerId" - this is Kaggle ID & nothing to do with the passenger

# "Survived" - again this info is given by Kaggle
# This is NOT quantitative data as  0 = NOT survive & 1 = survived
# Change to factor
titanic$Survived <- as.factor(titanic$Survived)

# "Pclass" - passenger class
# Again, not quantitative 
titanic$Pclass <- as.factor(titanic$Pclass)

# Let's get rid of the columns we are not going to use
titanic <- titanic %>% 
  select(Pclass, Sex, Age, Fare, Survived)

summary(titanic)

sum(is.na(titanic$Sex))
# [1] 0

sum(is.na(titanic$Age))
# [1] 177 :/

sum(is.na(titanic$Fare))
# [1] 0

sum(is.na(titanic$Pclass))

sum(is.na(titanic$Survived))

# use this to introduce functions
mean(titanic$Age, na.rm = T)

# use this if_else to introduce functions
titanic$Age <- if_else(is.na(titanic$Age), mean(titanic$Age, na.rm = T), titanic$Age)

# titanic_small <- titanic %>% 
#   select(Survived, Pclass, Sex, Age)

titanic$Sex <- as.factor(if_else(titanic$Sex == "female", 1, 0))

# titanic_small$Embarked <- if_else(titanic_small$Sex == "female", 1, 0)

set.seed(101)
train.set <- sample(1:nrow(titanic), round(nrow(titanic)*0.7))

tree.titanic <- tree(formula = Survived~., data = titanic, subset = train.set, )
plot(tree.titanic)
text(tree.titanic, pretty = 0)
tree.titanic

tree.pred = predict(tree.titanic, titanic[-train.set,], type = "tree")

# NOT WORKING
with(titanic[-train.set,], table(tree.pred, Survived))

# 
cv.titanic= cv.tree(tree.titanic, FUN = prune.misclass)
cv.titanic
# $size
# [1] 8 7 5 3 2 1
# 
# $dev
# [1] 114 114 118 127 137 248
# 
# $k
# [1]  -Inf   0.0   3.0   6.5  11.0 113.0
# 
# $method
# [1] "misclass"
# 
# attr(,"class")
# [1] "prune"         "tree.sequence"

plot(cv.titanic)

prune.titanic = prune.misclass(tree.titanic, best = 6)
plot(prune.titanic)
text(prune.titanic, pretty=0)
     