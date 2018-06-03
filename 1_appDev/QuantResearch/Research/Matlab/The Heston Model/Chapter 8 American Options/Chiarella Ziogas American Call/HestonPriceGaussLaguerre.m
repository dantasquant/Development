function y = HestonPriceGaussLaguerre(S,K,T,r,q,kappa,theta,sigma,lambda,v0,rho,PutCall,trap,x,w)

% Heston (1993) price by 32-point Gauss-Laguerre Quadrature
% Uses the original Heston formulation of the characteristic function,
% or the "Little Heston Trap" formulation of Albrecher et al.
% By Fabrice Douglas Rouah
% Returns the call price
% INPUTS -------------------------------------------------------
% S = Spot price.
% K = Strike
% T = Time to maturity.
% r = Risk free rate.
% kappa  = Heston parameter: mean reversion speed.
% theta  = Heston parameter: mean reversion level.
% sigma  = Heston parameter: volatility of vol
% lambda = Heston parameter: risk.
% v0     = Heston parameter: initial variance.
% rho    = Heston parameter: correlation
% trap:  1 = "Little Trap" formulation
%        0 = Original Heston formulation
% x = Gauss Laguerre abscissas
% w = Gauss Laguerre weights
% OUTPUT -------------------------------------------------------
% The Heston call price

% Numerical integration
for k=1:length(x);
	int1(k) = w(k)*HestonProb(x(k),kappa,theta,lambda,rho,sigma,T,K,S,r,q,v0,1,trap);
	int2(k) = w(k)*HestonProb(x(k),kappa,theta,lambda,rho,sigma,T,K,S,r,q,v0,2,trap);
end

% Define P1 and P2
P1 = 1/2 + 1/pi*sum(int1);
P2 = 1/2 + 1/pi*sum(int2);

% The Call price
CallPrice = S*exp(-q*T)*P1 - K*exp(-r*T)*P2;

% Output the option price
if strcmp(PutCall,'C')
	y = CallPrice;
else
	y = CallPrice - S*exp(-q*T) + K*exp(-r*T);
end

