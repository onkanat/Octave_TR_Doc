clear; clc; close all;
1;

%% 0. Hazirlik: basasiz oturumda Qt/cocoa yok -> pencere gosterilmez
warning("off", "all");
graphics_toolkit("gnuplot");

%% Yerel fonksiyonlar: hesap makinesinin cekirdegi (GUI'den bagimsiz)
function y = fakt(n)
  % Faktoriyel: prod(1:n)
  y = prod(1:n);
end

function str = ifade_cevir(str, surum)
  % Ekrandaki ifadeyi Octave sozdizimine cevirir.
  %   surum = "duz"         : nottaki ilk surum (koru korune strrep)
  %   surum = "duzeltilmis" : "e" yalniz tek basina dururken exp(1) olur
  if strcmp(surum, "duz")
    str = strrep(str, "e", "exp(1)");
  else
    str = regexprep(str, '(^|[^A-Za-z_])e([^A-Za-z_]|$)', '$1exp(1)$2');
  end
  str = regexprep(str, '(\d+)!', 'fakt($1)');
  str = strrep(str, "x^y", "^");
  str = strrep(str, "log", "log10");
end

function [deger, ekran] = ifade_degerlendir(ifade, surum)
  % Donusum + eval + hata yakalama: butonun ve Enter tusunun ortak yolu.
  % eval() burada bilincli tercihtir: notun konusu hesap makinesinin ifade
  % degerlendirmesi; girdi yalniz tus takimindan gelen yerel dizedir, dis
  % kaynaktan veri alinmaz. Hatali ifade try/catch ile "Hata!" ekranina duser.
  try
    str = ifade_cevir(ifade, surum);
    deger = eval(str);
    ekran = num2str(deger);
  catch
    deger = NaN;
    ekran = "Hata!";
  end
end

%% 1. Konsol demosu: ornek ifadeler (GUI olmadan da cekirdek calisir)
ornekler = {"2+3*4", "sin(pi/2)", "sqrt(16)", "5!", "log(100)", "(5!)/(3!*2!)", "e^2"};
printf("[1] %d ornek ifade, donusum + eval:\n", numel(ornekler));
for i = 1:numel(ornekler)
  [deger, ekran] = ifade_degerlendir(ornekler{i}, "duzeltilmis");
  printf("[1]   %-16s -> %-28s = %s\n", ornekler{i}, ...
         ifade_cevir(ornekler{i}, "duzeltilmis"), ekran);
end

%% 2. Bilinen hata: koru korune "e" degistirme exp() cagrisini bozar
printf("[2] ayni ifade iki surumde:\n");
for surum = {"duz", "duzeltilmis"}
  cevrilmis = ifade_cevir("exp(2)", surum{1});
  [~, ekran] = ifade_degerlendir("exp(2)", surum{1});
  printf("[2]   %-13s -> %-24s = %s\n", surum{1}, cevrilmis, ekran);
end

%% 3. GUI kurulumu (basasiz): dugmeler olusturulur, pencere gosterilmez
butonlar = { "7", "8", "9", "/", "sin", "cos"; ...
             "4", "5", "6", "*", "tan", "log"; ...
             "1", "2", "3", "-", "sqrt", "x^y"; ...
             "0", ".", "=", "+", "(", ")"; ...
             "pi", "e", "!", "C", "", "" };
kurulan = 0;
try
  fig = figure("visible", "off", "Name", "Bilimsel Hesap Makinesi", ...
               "NumberTitle", "off", "MenuBar", "none");
  exprBox = uicontrol("Style", "edit", "Parent", fig, ...
                      "Position", [20 350 320 35], "FontSize", 14, ...
                      "HorizontalAlignment", "right", "String", "");
  btn_w = 50; btn_h = 40; gap = 10;
  start_x = 20; start_y = 290;
  for i = 1:rows(butonlar)
    for j = 1:columns(butonlar)
      etiket = butonlar{i,j};
      if isempty(etiket); continue; end
      uicontrol("Style", "pushbutton", "Parent", fig, "String", etiket, ...
                "Position", [start_x + (j-1)*(btn_w+gap), ...
                             start_y - (i-1)*(btn_h+gap), btn_w, btn_h], ...
                "FontSize", 12);
      kurulan = kurulan + 1;
    end
  end
  bulunan = numel(findobj(fig, "Style", "pushbutton"));
  printf("[3] GUI: 1 girdi kutusu + %d dugme kuruldu, figure'da bulunan: %d\n", ...
         kurulan, bulunan);
  close(fig);
  printf("[3] pencere basasiz oturumda gosterilmedi ve kapatildi (Qt yok)\n");
catch e
  printf("[3] GUI kurulamadi: %s\n", e.message);
end

%% 4. Dugme etiketleri: kac tanesi ve hangi gruplar
printf("[4] tus takimi: %dx%d izgara, %d dolu hucre, %d bos hucre\n", ...
       rows(butonlar), columns(butonlar), kurulan, rows(butonlar)*columns(butonlar) - kurulan);
printf("[4] bilimsel fonksiyon dugmeleri: sin, cos, tan, log, sqrt, x^y\n");
printf("[4] sabit dugmeleri: pi, e;  islem dugmeleri: +, -, *, /, ^, !, (, )\n");

%% Ozet
printf("\nOzet: donusum + eval cekirdegi %d ifade uzerinde olculdu; GUI iskeleti\n", ...
       numel(ornekler));
printf("      %d dugme ile kuruldu. Gercek pencere icin Qt toolkit gerekir\n", kurulan);
printf("      (bu makinede yalniz fltk ve gnuplot var).\n");
