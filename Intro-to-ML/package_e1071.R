#Getting started with Naive Bayes
#Install the package
#install.packages("e1071")
#Loading the library
library(e1071)

xy <- data.frame(
  x.1 = c(-1, -2, -3, 1, 2, 3), 
  x.2 = c(-1, -1, -2, 1, 1, 2),
  y = c(1, 1, 1, 2, 2, 2)
  )

str(xy)

xy$y <- as.factor(xy$y)

str(xy)

clf <- naiveBayes(y ~ ., data = xy, laplace = 0)

clf

predict(object = clf,
        data.frame(x.1 = -0.8, x.2 = -1))
