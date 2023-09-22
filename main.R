library(zoo)
library(xts)
library(knitr)
library(PerformanceAnalytics)
library(ggplot2)
library(lmtest)
library(forecast)
library(dplyr)
library(tseries)
library(urca)
library("vars")
library(AER)
library(lubridate)

data = read.csv("data.csv")
data = as.xts(data[, -c(1, 2)], order.by = as.Date(data$date))
colnames(data) = c('Apple', 'Copart_inc')
is.null(data)

autoplot(data)

# Apply Phillips-Perron test
pp.test(data[,1])

# Apply KPSS test.
kpss.test(data[,1])

# Apply simple augmented Dickey-Fuller. 
x<-ur.df(data[,1], type = "none", selectlags = "AIC")
summary(x)

# Apply Phillips-Perron test
pp.test(data[,2])

# Apply KPSS test.
kpss.test(data[,2])

# Apply simple augmented Dickey-Fuller. 
x<-ur.df(data[,2], type = "none", selectlags = "AIC")
summary(x)

log = log(data)
autoplot(log)
log = as.xts(log)

# First difference
diff_data = diff.xts(data, 1, 1)
#remove first NA value
diff_data = diff_data[-1, ]
autoplot(diff_data)

# First difference
log_diff = diff.xts(log, 1, 1)
#remove first NA value
log_diff = log_diff[-1, ]
autoplot(log_diff)

#remove outliers
t1 = tsoutliers(as.ts(log_diff[,1]),iterate=5, lambda = NULL)
log_diff[t1$index] = t1$replacements

t2 = tsoutliers(as.ts(log_diff[,2]),iterate=5, lambda = NULL)
log_diff[t2$index] = t2$replacements

autoplot(log_diff)

# Apply Phillips-Perron test
pp.test(log_diff[,1])

# Apply KPSS test.
kpss.test(log_diff[,1])

# Apply simple augmented Dickey-Fuller.
x<-ur.df(log_diff[,1], type = "none", selectlags = "AIC")
summary(x)

# Apply Phillips-Perron test
pp.test(log_diff[,2])

# Apply KPSS test.
kpss.test(log_diff[,2])

# Apply simple augmented Dickey-Fuller.
x<-ur.df(log_diff[,2], type = "none", selectlags = "AIC")
summary(x)

ggAcf(log_diff$Apple) + labs(title = "ACF PLot of Apple returns")
ggAcf(log_diff$Copart_inc) + labs(title = "ACF PLot of Copart inc. returns")

VARselect(log_diff, lag.max = 20, type = "none", season = NULL, exogen = NULL)

#cointegration test
library(urca)
jotest=ca.jo(log, type="eigen", K=2,
             ecdet="none", spec="longrun")
summary(jotest)

#cointegration test
library(urca)
jotest=ca.jo(log, type="trace", K=2,
             ecdet="none", spec="longrun")
summary(jotest)

m2 = VAR(log_diff, p = 1, type = "const")
summary(m2)
ggAcf(residuals(m2))+ labs(title = "ACF PLot of model residuals")
roots(m2, modulus = TRUE)
checkresiduals(m2$varresult$Apple$residuals)
checkresiduals(m2$varresult$Copart_inc$residuals)
arch.test(m2)
s1 = stability(m2, type= "OLS-CUSUM")
plot(s1)
plot(irf(m2,ci=0.95, boot =TRUE, ortho=TRUE, n.ahead = 3, runs = 100))
plot(irf(m2,ci=0.95, boot =TRUE, ortho=TRUE, n.ahead = 3, runs = 1000))
