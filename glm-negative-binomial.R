# Negative Binomial GLM ---------------------------------------------------

library(rstan)
library(MASS)


# Data --------------------------------------------------------------------

data("quine", package = "MASS")




# Using MASS::glm.nb() ----------------------------------------------------

# From the example of glm.nb()
quine.nb1 <- glm.nb(Days ~ Sex/(Age + Eth*Lrn), data = quine)
quine.nb2 <- update(quine.nb1, . ~ . + Sex:Age:Lrn)
quine.nb3 <- update(quine.nb2, Days ~ .^4)


mm <- model.matrix(Days ~ Sex/(Age + Eth*Lrn), data = quine)

# Stan --------------------------------------------------------------------

nb1 <- "
data {
  int<lower=0> N;
  int<lower=0> K;
  vector[N] days;
  matrix[N, K] x;
}

parameters {
  real alpha;
  vector[K] beta;
  real<lower=0> sigma;
}

model {
  days ~ neg_binomial(alpha + x * beta, sigma);
}
"

fit <- stan(
  model_code = nb1, 
  data = list(
    days = quine$Days,
    x = mm,
    N = length(quine$Days),
    K = ncol(mm)
  )
)
