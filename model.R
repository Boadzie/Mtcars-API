library(caret)
library(httr)
library(magrittr)
library(plumber)
library(tidyverse)


# Load data
df <- mtcars %>% as_tibble()

df %>% head

# Correlation
df %>% cor %>% corrplot::corrplot()



# Split tehe data
set.seed(seed = 0)

# Define observation matrix. 
X <- df %>% select(wt, qsec, am)
# Define target vector.
y <- df %>% pull(mpg)

# Define a partition of the data. 
partition <- createDataPartition(y = y, p = 0.75, list = FALSE) 

# Split the data into a training and test set. 
df.train <- df[partition, ]
df.test <- df[- partition, ]

X.train <- df.train %>% select(wt, qsec, am)
y.train <- df.train %>% pull(mpg)

X.test <- df.test %>% select(wt, qsec, am)
y.test <- df.test %>% pull(mpg)


# Data Pre-Processing

# Define scaler object. 
scaler.obj <- preProcess(x = X.train, method = c('center', 'scale'))

# Transform the data. 
X.train.scaled <- predict(object = scaler.obj, newdata = X.train)
X.test.scaled <- predict(object = scaler.obj, newdata = X.test)



# Model Evaluation

model.obj$results %>% select(RMSE)

# On test
y.pred <- predict(model.obj, newdata = X.test.scaled)

RMSE(pred = y.pred, obs = y.test)


# Visualize it
tibble(y_test = y.test, y_pred = y.pred) %>% 
  ggplot() + 
  theme_light() + 
  geom_point(mapping = aes(x = y_test, y = y_pred)) + 
  geom_smooth(mapping = aes(x = y_test, y = y_pred, colour = 'y_pred ~ y_test'), method = 'lm', formula = y ~ x) + 
  geom_abline(mapping = aes(slope = 1, intercept = 0, colour = 'y_pred = y_test'), show.legend = TRUE) +
  ggtitle(label = 'Model Evaluation')


# Save the Model
GetNewPredictions <- function(model, transformer, newdata){
  
  newdata.transformed <- predict(object = transformer, newdata = newdata)
  
  new.predictions <- predict(object = model, newdata = newdata.transformed)
  
  return(new.predictions)
  
}

# Save ouput object
# Define Output object.
model.list <- vector(mode = 'list')
# Save scaler object.
model.list$scaler.obj <- scaler.obj
# Save fitted model.
model.list$model.obj <- model.obj
# Save transformation function. 
model.list$GetNewPredictions <- GetNewPredictions

saveRDS(object = model.list, file = 'model_list.rds')