# http://www.r-tutor.com/gpu-computing/rbayes/rhierlmc
# Problem

# Fit the data set cheese with the hierarchical linear model, and estimate
# the average impact on sales volumes of the retailers if the unit retail
# price is to be raised by 5%.

# Solution

# Our first task is to divide the data according to regional retailers. The
# following shows that the RETAILER column has the factor data type, which
# allow us to extract the entire list of retailer accounts with the levels
# method.

library(bayesm) 
data(cheese) 
str(cheese) 

retailer <- levels(cheese$RETAILER)
nreg <- length(retailer)
nreg 

# Let i to be an integer between 1 and the number of retailer accounts. We
# define a filter for the i-th account as follows.

# filter <- cheese$RETAILER==retailer[i]

# We now loop through the accounts, and create a list of data items
# consisting of the X and y components of the linear regression model
# in each account. The columns of X below contains the intercept
# placeholder, the display measure, and log price data.

regdata <- NULL 
for (i in 1:nreg) { 
    filter <- cheese$RETAILER==retailer[i] 
    y <- log(cheese$VOLUME[filter]) 
    X <- cbind(1,      # intercept placeholder 
            cheese$DISP[filter], 
            log(cheese$PRICE[filter])) 
    regdata[[i]] <- list(y=y, X=X) 
}

# Finally, we wrap the regdata and the iteration parameters in lists,
# and invoke the rhierLinearModel method of the bayesm package. It
# takes about half a minute for 2,000 MCMC iterations on an average CPU.

Data <- list(regdata=regdata) 
Mcmc <- list(R=2000) 
 
system.time( 
  out <- bayesm::rhierLinearModel( 
         Data=Data, 
         Mcmc=Mcmc)) 

#   user  system elapsed 
# 30.962   0.032  31.024

# We can perform the same MCMC simulation with an identically named method
# in rpudplus. The same process finishes under 0.5 second. Note the
# extra output option that we explicitly set to be ’bayesm’ for
# compatibility.

library(rpud)    # load rpudplus 
system.time( 
  out <- rpud::rhierLinearModel( 
         Data=Data, 
         Mcmc=Mcmc, 
         output="bayesm")) 

#   user  system elapsed 
#  0.152   0.056   0.212

# Observe that the log price data is in the third column of the X component.
# Hence we can estimate the log price coefficient from the third component
# of the second dimension in the betadraw attribute of the MCMC output. We
# also drop the first 10% samples for burn-in, i.e. 200 MCMC draws, before
# evaluating the mean of the simulation values.

beta.3 <- mean(as.vector(out$betadraw[, 3, 201:2000])) 
beta.3 

#[1] −2.146

# A 5% increase of the unit price amounts to an increment of log(1.05) in
# the log price. Therefore the log sales volume will be adjusted by
# −2.146 ∗ log(1.05). The computation below shows that the sales volume
# is expected to decrease by 10% on average.

exp(beta.3*log(1.05))

# [1] 0.9006 
