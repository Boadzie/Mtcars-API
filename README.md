# Mtcars-API
An R machine Learning API to predict Miles per Gallon using Caret, Plumber and Swagger

### Expose Enpoint
```r
# to expose the endpoint run the following in the Rstudio console
setwd(dir = here::here())

r <- plumb(file = 'plumber.R')

r$run(port = 8000)
```

### Swagger api endpoint
```r
   http://127.0.0.1:8000/__swagger__/
```

### Normal endpoint 
```r
   http://localhost:8000/predict
```
