rm(list=ls())

get_cloglik <- function(X, Z, theta) {
  alpha <- theta$alpha; mu <- theta$mu; sigma <- theta$sigma
  xs <- scale(matrix(X, length(X), length(alpha)), mu, sigma)
  res <- sum(Z*(log(alpha) - log(sigma) - .5*(log(2*pi) + xs^2)))
  res
}
M_step <- function(X, tau) {
  n <- length(X); Q <- ncol(tau)
  alpha  <- colMeans(tau)
  mu     <- colMeans(tau * matrix(X,n,Q)) / alpha
  sigma  <- sqrt(colMeans(tau *sweep(matrix(X,n,Q), 2,  mu, "-")^2) / alpha)  
  list(alpha = alpha, mu = mu, sigma = sigma)
}

E_step <- function(X, theta) {
  prob <- mapply(function(alpha, mu, sigma) {
    alpha*dnorm(X,mu,sigma)
  }, theta$alpha, theta$mu, theta$sigma)
  likelihoods <- rowSums(prob)
  list(tau = prob / likelihoods, loglik = sum(log(likelihoods)))
}

EM_mixture <- function(X, Q,
                       init.cl = kmeans(X,Q)$cl, max.iter=100, eps=1e-5) {
    n <- length(X); tau <- matrix(0,n,Q); tau[cbind(1:n,init.cl)] <- 1
    loglik  <- vector("numeric", max.iter)
    Eloglik <- vector("numeric", max.iter)
    iter <- 0; cond <- FALSE

    while (!cond) {
        iter <- iter + 1
        ## M step
        theta <- M_step(X, tau)
        ## E step
        res_Estep <- E_step(X, theta)
        tau <- res_Estep$tau
        ## check consistency
        loglik[iter]  <- res_Estep$loglik
        Eloglik[iter] <- get_cloglik(X, tau, theta)
        if (iter > 1)
            cond <- (iter >= max.iter) | Eloglik[iter] - Eloglik[iter-1] < eps
    }

    res <- list(alpha = theta$alpha,  mu = theta$mu,  sigma = theta$sigma,
                tau   = tau, cl = apply(tau, 1, which.max),
                Eloglik = Eloglik[1:iter],
                loglik  = loglik[1:iter])
    res
}

## checking against mixtools results
library(mixtools)

mu1 <- 5   ; sigma1 <- 1; n1 <- 100
mu2 <- 10  ; sigma2 <- 1; n2 <- 200
mu3 <- 2.5 ; sigma3 <- 2; n3 <- 50
mu4 <- 20  ; sigma4 <- 4; n4 <- 100
x <- sample(c(rnorm(n1,mu1,sigma1),rnorm(n2,mu2,sigma2),
              rnorm(n3,mu3,sigma3),rnorm(n4,mu4,sigma4)))
n <- length(x)

seq.Q <- 2:10

crit.EM <- sapply(seq.Q, function(Q) {
    out <- EM_mixture(x, Q)
    df <- Q-1 + 2 * Q
    return(c(BIC = -2*tail(out$loglik ,1) + log(n)*df,
             ICL = -2*tail(out$Eloglik,1) + log(n)*df ))
})

EM.Q2 <- EM_mixture(x, Q=2)

EM.ref <- normalmixEM(x)
EM.ref$mu
EM.ref$sigma
EM.ref$lambda
