# **TimeSeriesModeling** <img src="edit1.0.png" width="50" height="50">
### Keywords 
R programming | time series | stationarity | vector autoregressive model | cointegration | heteroscedasticity | robust check
### Purpose
In investment analysis, changes in stock prices are often described either by classical set of fundamental drivers or also by such technical factors as, for example, changes in stock prices of "peer companies" (companies with similar capitalization and industry). While the issue of mutual influence of stock prices of companies differing in capitalization and product line is insufficiently studied.

Moreover, there is no consensus in the scientific community on the duration of the effect persistence (if it is), as well as on the presence or absence of autoregressive effect in the mutual influence.

**This project aims to identify vector autoregression between Apple and Copart inc. stock prices.**

### Data
The sample includes data on the closing prices, adjusted for dividends paid and splits performed, of the stocks of two companies from the NASDAQ-100 index: Apple and COPART Inc. The data include stock prices for each day the exchange was open from March 17, 1994 through March 27, 2018. Accordingly, data are not presented for dates associated with weekends and holidays. However, since the stock exchange was not operating on these days, the corresponding observations cannot be considered as missing values.
Data source: yahoo finance parsing | python

### Research structure 
1. Stationarity check (need no trend and homoscedasticity):  PP, KPSS, ADF tests
2. Reduction of variance spread (fight against heteroscedasticity) and trend neutralization: log-diff transformation
Transition to logarithmic returns.

$$ r_t = \ln\left(\frac{P_t}{P_{t-1}}\right) $$

4. Removing outliers 
5. Constructing corrolelograms, detecting autocorrelation 
6. Checking for cointegration. Choosing between VAR and VECM 
7. Selection of the number of lags: HQ, SC criteria
8. Determination of cointegration rank: Johansen Trace and Eigen tests
9. Absence of cointegration.  Modeling VAR in differences

System of equations: 

$$ Y_{1t} = {alpha_{1}} + {alpha_{11}}{Y_{1,t-1}} + {alpha_{12}}{Y_{2,t-1}} + {e_{1,t}} $$

$$ Y_{2t} = {alpha_{2}} + {alpha_{21}}{Y_{2,t-1}} + {alpha_{22}}{Y_{2,t-1}} + {e_{2,t}} $$


11. Checking residuals
12. Checking for structural shift
13. Impulse Response Function construction
14. Robustness check, bootstrap

### Insights
Estimated system of equations: 

$$ A_{t} = {0.001} + {0.014}{C_{t-1}} + {0.002}{A_{t-1}} + {e_{1,t}} $$

$$ C_{t} = {0.001} + {0.014}{A_{t-1}} - {0.047}{C_{t-1}} + {e_{2,t}} $$

1. 1 standard deviation increase in Apple stock returns will have a meaningful positive impact on COPART Inc. returns with a duration of 1 period, further 0 falls within the confidence interval, so we cannot estimate the impact.
2. An increase in COPART Inc. stock returns will have no meaningful effect on Apple stock returns.
3. The effect of a shock to both variables on their stock returns will persist for one period before returning to equilibrium.

Thus, we obtain that a change in the stock return of a larger capitalization firm has an effect on the stock return of a smaller capitalization firm, but not vice versa. The stock return of a large-capitalization firm is independent of the stock return of a smaller-capitalization firm.
