#' Creates three gaussian clusters with replacement outliers
#'
#' @param N_k int. Number of samples in each cluster.
#' @param epsilon scalar. Percentage of outliers
#'
#' @return list
#' \enumerate{
#' \item data matrxi[3*N_k, 2] Samples
#' \item labels vector[N] Cluster memberships of the samples
#' \item r int. Number of dimensions in generated data. Set to 2
#' \item N int. Total number of samples. Set to 3*N_k
#' \item K_true int. Number of clusters. Set to 3
#' \item mu_true matrix[r, K_true] Cluster means
#' \item scatter_true array[r, r, K_true] Cluster scatter matrices
#' }
#'
#'
#' @note
#'
#' "Robust M-Estimation based Bayesian Cluster Enumeration for Real Elliptically Symmetric Distributions"
#' Christian A. Schroth and Michael Muma, Signal Processing Group, Technische UniversitÃ¤t Darmstadt
#' submitted to IEEE Transactions on Signal Processing
#' @examples
#'
#' @export
data_31 <- function(N_k, epsilon){
  out_range <- matrix(c(-20, -20, 20, 20), 2, 2)
  K_true <- 3 # number of clusters
  r <- 2 # number of features

  mu_true <- matrix(c(0, 5, 5, 0, -5, 0), 2, 3)

  scatter_true <- array(0, c(r, r, K_true))
  scatter_true[,,1] <- c(2, .5, .5, .5)
  scatter_true[,,2] <- c(1, 0, 0, 0.1)
  scatter_true[,,3] <- c(2, -.5, -.5, .5)
  N <- K_true * N_k # total number of data points

  data <- numeric(0)
  for(k in 1:K_true){
    data <- rbind(data, cbind(rep(1, N_k)*k, MASS::mvrnorm(n = N_k, mu = mu_true[,k], Sigma = scatter_true[,,k])))
  }

  # randomly permute data
  data <- data[pracma::randperm(dim(data)[1]),]

  # replacement outlier
  N_repl <- round(N * epsilon)
  index_repl <- pracma::randperm(N, N_repl)

  data_rpl <- numeric(0)
  for(ir in 1:r){
    data_rpl <- cbind(data_rpl, pracma::rand(N_repl, 1) * (out_range[ir,2]-out_range[ir,1])+out_range[ir,1])
  }

  data[index_repl,] <- cbind(rep(1, N_repl)*(K_true+1), data_rpl)

  labels <- data[,1]
  data <- data[,-1]
  return(list(data=data,labels=labels,r=r,N=N,K_true=K_true,mu_true=mu_true, scatter_true=scatter_true))
}

