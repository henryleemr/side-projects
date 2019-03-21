

T = [435.85, 523.549,496.729, 514.627,490.768, 507.419,500.195	];
% in Celcius, the new ones getting 45kmol/h
T2 = [185.85, 416.72, 179.66, 366.428, 268.575, 326.34, 318.727];

X = [0, 0.4, 0.4, 0.8, 0.8, 1.2, 1.2];
% coefficients = polyfit(X,T,1);
% T = polyval(coefficients,T);

plot(X,T, 'LineWidth', 0.9);
title('Temperature across Length of Reactor Beds')
xlabel('Length/m')
ylabel('Temperature/C')
grid on
set(gca,'fontsize',12, 'FontWeight', 'bold')

A = [523.549,496.729, 514.627,490.768, 507.419,500.195];
Average = mean(T)
Average2 = mean(T2)