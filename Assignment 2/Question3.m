clear;
path = "C:/Users/bowus/OneDrive - Emory/PhD Economics/Year 2/Time Series/Homework/Assignment 2/";
data =  readtable(path + "ND000336Q.xls");
data(1:2,:) = [];
growthRates = diff(log(table2array(data(:,end))));
Time = data.ND000336Q(2:end,:);

Y_t = timetable(Time,growthRates);
%% check the stationarity
plot(Time,growthRates,"-")
title("The Growth rates NonResidential Private Investment")
xlabel("Quarter")
ylabel("Growth Rates")
saveas(gcf,'growthRates.png')

%
autocorr(growthRates,45);

%% Quetsion b: Estimate AR(4)
nlags = 4;
X_t = lagmatrix(Y_t,1:nlags); %create the lags of Y
X_t = table2array(X_t(nlags+1:end,:)); % Remove the lost observations
Y_ar = table2array(Y_t(nlags+1:end,:)); 

% Use 3 estimation methods
%1. Linear model estimation: Use M-estimation algorithm
mdl = fitlm(X_t,Y_ar,'RobustOpts','on');
mdl.Coefficients

%% 2 Use the OLS estimation:
[b_OLS, ~, ~, ~, stats] = regress(Y_ar, [ones(height(Y_ar), 1), X_t]);

%3 Use the ar function to estimate an AR(4) model
ar_model = ar(growthRates, 4, 'ls');
b_ar = ar_model.A ;

% 4. Hac Method or the Newey west Coefficients
%Calculate heteroskedastic-consistent standard errors
[EstCoeffCov,se,coeff] = hac(mdl, bandwidth = 5);





%% Calculate heteroskedastic-consistent standard errors

% Extract AR(4) coefficients
ar_coeffs = mdl.Coefficients.Estimate;  % Assuming fitlm was run as in your code
% The first coefficient is the intercept, so we only take the AR terms
phi = ar_coeffs(2:end);  % Coefficients corresponding to lags

% Number of periods for the IRF
num_periods = 10;

% Initialize the IRF array
irf = zeros(num_periods, 1);

% Impulse response starts with a shock of size 1 at time t=1
shock = 1;
irf(1) = shock;

% Compute the response for each subsequent period
for j = 2:num_periods
    if j-1 <= length(phi)
        irf(j) = phi(1:j-1)' * flip(irf(1:j-1));  % Apply the AR coefficients to past responses
    else
        irf(j) = phi' * flip(irf(j-length(phi):j-1));  % For j > 4, use all AR(4) coefficients
    end
end

% Plot the Impulse Response Function
figure;
stem(1:num_periods, irf, 'filled');
xlabel('Period (j)');
ylabel('Impulse Response');
title('Impulse Response Function for AR(4) Model');
grid on;
