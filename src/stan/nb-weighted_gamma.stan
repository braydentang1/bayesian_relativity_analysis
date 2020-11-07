data {
  int<lower=1> Nobs;
  int<lower=1> Nvar;
  matrix[Nobs, Nvar] X;
  int<lower=0> claim_count[Nobs];
  vector<lower=0>[Nobs] exposure;
  vector<lower=0>[Nobs] severity;
}

parameters {
  vector[Nvar] beta_frequency;
  vector[Nvar] beta_severity;
  real<lower=0> dispersion_severity;
  real<lower=0> dispersion_frequency;
}

transformed parameters {
  
}

model {
  
  beta_frequency ~ normal(0, 5);
  beta_severity ~ normal(0, 5);
  dispersion_severity ~ cauchy(0, 8);
  dispersion_frequency ~ cauchy(0, 8);
  
  claim_count ~ neg_binomial_2_log(X * beta_frequency + log(exposure), dispersion_frequency);
  
  for (i in 1:Nobs) {
    if (claim_count[i] != 0) {
      severity[i] ~ gamma(
      	claim_count[i] / dispersion_severity,
      	claim_count[i] / (exp(X[i] * beta_severity) * dispersion_severity)
      	);
    }
  }
  
}

