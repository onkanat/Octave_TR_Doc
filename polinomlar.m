clear; clc; close all;
rand("seed", 42);
randn("seed", 42);

%% 1. Polinomun katsayı vektörüyle gösterimi
p = [-2, -1, 0, 1, 2];
printf("p = [-2 -1 0 1 2] -> "); polyout(p, "x");

%% 2. Değerlendirme: polyval
p2 = [1, -2, 1];                 % x^2 - 2x + 1
xv = [0, 1, 2, 3];
yv = polyval(p2, xv);
printf("\npolyval([1 -2 1], 0:3)   : %s\n", mat2str(yv));

%% 3. Çarpım: conv
a = [1, 2];                      % x + 2
b = [1, -1];                     % x - 1
c = conv(a, b);
printf("conv([1 2], [1 -1])      : %s   (x^2 + x - 2)\n", mat2str(c));

%% 4. Bölüm: deconv
y = [1, 0, -1];                  % x^2 - 1
bolen = [1, -1];                 % x - 1
[bolum, kalan] = deconv(y, bolen);
printf("deconv([1 0 -1], [1 -1]) : bolum %s, kalan %s\n", mat2str(bolum), mat2str(kalan));

%% 5. Kökler: roots
pr = [1, -5, 6];                 % x^2 - 5x + 6
kokler = sort(roots(pr));
printf("roots([1 -5 6])          : %s\n", mat2str(kokler', 6));

%% 6. Türev ve integral: polyder / polyint
pt = [1, 0, -3, 2];              % x^3 - 3x + 2
turev = polyder(pt);
printf("polyder([1 0 -3 2])      : %s   (3x^2 - 3)\n", mat2str(turev));
integ = polyint(turev);
printf("polyint([3 0 -3])        : %s   (x^3 - 3x, sabit 0)\n", mat2str(integ));

%% 7. Veri uydurma: polyfit
xd = [0, 1, 2, 3, 4];
yd = [1, 2, 5, 10, 17];
pu = polyfit(xd, yd, 2);
printf("\npolyfit(0:4, [1 2 5 10 17], 2) : %s\n", mat2str(pu, 6));
printf("uydurma artigi max       : %.2e\n", max(abs(polyval(pu, xd) - yd)));

%% 8. Tuzak: polinom toplama
pa = [1, 0, -1];                % x^2 - 1
pb = [1, 1];                    % x + 1
try
  pa + pb;
catch err
  printf("\npa + pb hata verdi  : %s\n", err.message);
end
pb_uzat = [0, pb];              % basa sifir eklemek polinomu degistirmez
printf("pa + [0 pb]          : %s\n", mat2str(pa + pb_uzat));
printf("polyout sonucu       : "); polyout(pa + pb_uzat, "x");

%% 9. Uygulama: hareket denklemi (y = y0 + v0 t + 0.5 a t^2)
t = [0, 0.5, 1.0, 1.5, 2.0, 2.5];
ym = [10, 12.5, 14.0, 14.5, 14.0, 12.5];
ph = polyfit(t, ym, 2);
ivme = 2 * ph(1);
v0   = ph(2);
y0   = ph(3);
printf("\nUydurulan hareket: a = %.2f m/s^2, v0 = %.2f m/s, y0 = %.2f m\n", ivme, v0, y0);
printf("uydurma artigi max : %.2e m\n", max(abs(polyval(ph, t) - ym)));

%% 10. Aşırı uyum: 2. derece ile 9. derece karşılaştırması
x = -5:1:5;
y_gercek = 0.5 * x.^2 - 2 * x + 3;
y_gurultulu = y_gercek + 2.5 * randn(size(x));
p2d = polyfit(x, y_gurultulu, 2);
p9d = polyfit(x, y_gurultulu, 9);
rmse2 = sqrt(mean((polyval(p2d, x) - y_gurultulu).^2));
rmse9 = sqrt(mean((polyval(p9d, x) - y_gurultulu).^2));
printf("\n2. derece RMSE     : %.4f  (veriye uyum)\n", rmse2);
printf("9. derece RMSE     : %.4f  (egitim verisine neredeyse tam uyum)\n", rmse9);
x_test = -4.5:1:4.5;
rmse2t = sqrt(mean((polyval(p2d, x_test) - (0.5 * x_test.^2 - 2 * x_test + 3)).^2));
rmse9t = sqrt(mean((polyval(p9d, x_test) - (0.5 * x_test.^2 - 2 * x_test + 3)).^2));
printf("2. derece RMSE (yeni veri): %.4f\n", rmse2t);
printf("9. derece RMSE (yeni veri): %.4f  <- asiri uyum burada gorunur\n", rmse9t);

%% 11. Uygulama: ekonomik trend tahmini
yillar = 2015:1:2024;
fiyatlar = [50, 55, 62, 70, 80, 85, 95, 110, 130, 155];
p_trend = polyfit(yillar, fiyatlar, 2);
gelecek = 2025:1:2029;
tahmin = polyval(p_trend, gelecek);
printf("\nYil      Tahmini fiyat (TL)\n");
for i = 1:numel(gelecek)
  printf("%d     %8.2f\n", gelecek(i), tahmin(i));
end
printf("egri egilimi (2025->2029): %.2f TL/yil ortalama artis\n", ...
       (tahmin(end) - tahmin(1)) / (numel(gelecek) - 1));

%% Özet
printf("\nOzet: polyout, polyval, conv, deconv, roots, polyder, polyint, polyfit\n");
printf("      8 polinom fonksiyonu; 2 tuzak, 3 uygulama olculdu.\n");
