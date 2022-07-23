# Linear model from lm() example

library(rstan)


# Data --------------------------------------------------------------------

# Data from ?lm

ctl <- c(4.17,5.58,5.18,6.11,4.50,4.61,5.17,4.53,5.33,5.14)
trt <- c(4.81,4.17,4.41,3.59,5.87,3.83,6.03,4.89,4.32,4.69)
group <- gl(2, 10, 20, labels = c("Ctl","Trt"))
weight <- c(ctl, trt)



# lm() --------------------------------------------------------------------

# lm() fits

lm.fit <- lm(weight ~ group)
lm.fit1 <- lm(weight ~ group - 1) # omitting intercept



# Stan --------------------------------------------------------------------

m <- "data {
  int<lower=0> N;
  vector[N] group;
  vector[N] weight;
}
parameters {
  real alpha;
  real beta;
  real<lower=0> sigma;
}
model {
  weight ~ normal(alpha + beta * group, sigma);
}"

stan.fit <- stan(
  model_code = m,
  data = list(group = as.integer(group == "Ctl"), 
              weight = weight, 
              N = length(weight)),
  verbose = TRUE
)
