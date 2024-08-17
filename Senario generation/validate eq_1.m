n = 1000;
x_nm = linspace(0,64,n); % in nm
W_kt = zeros(n,1); % in kn
rmw_nm = 15; % in nm
wm_kt = 70; % in kt
rs_nm = 64; % in nm

for i =1:n
    W_kt(i) = calculate_static_wind(x_nm(i),rmw_nm,wm_kt,rs_nm);
end


x_km = x_nm * 1.83;
W_ms = zeros(n,1); % in m/s
rmw_km = rmw_nm * 1.83; % in km
wm_ms = wm_kt * 0.51;
rs_km = rs_nm * 1.83;
for i =1:n
    W_ms(i) = calculate_static_wind(x_km(i),rmw_km,wm_ms,rs_km);
end
x_2 = x_km/1.83;
W_2 = W_ms / 0.51;
delta = W_kt-W_2;
figure
subplot(3,1,1);
plot(x_nm,W_kt);
subplot(3,1,2);
plot(x_2, W_2);
subplot(3,1,3);
plot(x_2,delta);