function [fitresult, gof] = createFit(N, optimal_prob_set, ps)
%CREATEFIT(T,OPTIMAL_PROB_SET)
%  Create a fit.
%
%  Data for 'untitled fit 1' fit:
%      X Input : t
%      Y Output: optimal_prob_set
%  Output:
%      fitresult : a fit object representing the fit.
%      gof : structure with goodness-of fit info.
%
%  See also FIT, CFIT, SFIT.

%  Auto-generated by MATLAB on 31-Oct-2018 14:02:30


%% Fit: 'untitled fit 1'.
[xData, yData] = prepareCurveData(0:length(optimal_prob_set) - 1, optimal_prob_set );

% Set up fittype and options.
str = sprintf('min((1/%d)*(a^x), 0.5)', N);
ft = fittype( str, 'independent', 'x', 'dependent', 'y' );
opts = fitoptions( 'Method', 'NonlinearLeastSquares' );
opts.Display = 'Off';
opts.Robust = 'LAR';
opts.StartPoint = 0.0853050398596331;

% Fit model to data.
[fitresult, gof] = fit( xData, yData, ft, opts );

% Plot fit with data.
figure( 'Name', 'untitled fit 1' );
h = plot( fitresult, xData, yData );
legend( h, 'optimal_prob_set vs. t', 'untitled fit 1', 'Location', 'NorthEast' );
% Label axes
xlabel t
ylabel optimal_prob_set
grid on

str = sprintf('Growth_rule_policies/OptimalPolicy_%d_%d', N, ps*1000);
save(str,'fitresult', 'gof')


