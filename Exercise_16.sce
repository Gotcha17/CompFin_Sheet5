clc; clear; //clears the console and all previously stored variables

function V_t = BS_Price_DownOut_Call (r, sigma, S_t, T, K, H, t)
    //using matlab function to calculate prob. of a std. norm.
    function p = Phi(x)
       p = cdfnor("PQ", x, zeros(x), ones(x));
    endfunction
    //defining all used formuals in the BS down-and-out call
    log1 = log(S_t./K);
    log2 = log((H^2)./(K.*S_t));
    d1 = ( log1 + (r+1/2*sigma^2)*(T-t) ) ./ ( sigma*sqrt(T-t) );
    d2 = d1 - sigma*sqrt(T-t);
    d3 = ( log2 + (r+1/2*sigma^2)*(T-t) ) ./ ( sigma*sqrt(T-t) );
    d4 = d3 - sigma*sqrt(T-t);
    V_t = (S_t.*(Phi(d1) - (H./S_t)^(1+2*r/sigma^2).*Phi(d3)) - K.*(exp(-r*(T-t)).*Phi(d2) - (H./S_t)^(2*r/sigma^2-1).*Phi(d4)))*(S_t>=H);
    
endfunction

 scf(0);
 clf()
r=0.03; sigma=0.3; T=1; H=80; S_t=70:130; t=0:(1/(length(S_t)-1)):1; K=[80, 90, 100, 120];

//running two for loops, outter for different strike prices
for j=1:4
    //inner for loop for the range of stock prices
    for i=min(S_t):max(S_t)
        X(:,i-69) = BS_Price_DownOut_Call (r, sigma, i, T, K(1,j), H, t);
    end
//each surface is plotted for respective strike price in one figure
subplot(2,2,j)
surf(S_t, t, X);
xtitle("Down-and-out call with strike " + string(K(1,j)), "S_t", "t", "V_t" )
end

