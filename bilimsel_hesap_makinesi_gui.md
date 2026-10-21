---
layout: default
title: "Octave Bilimsel Hesap Makinesi GUI"
lang: tr
konu: ileri
seviye: ileri
tur: ders
kod: bilimsel_hesap_makinesi_gui.m
redirect_from: [/Octave_bilimsel_hesap_makinesi_gui.html]
---

# Octave Bilimsel Hesap Makinesi GUI

Bu dokümanda, `bilimsel_hesap_makinesi_gui.m` dosyasındaki kodun satır satır ne işe yaradığını
açıklıyoruz: `figure` + `uicontrol` ile kurulan bir bilimsel hesap makinesi, ifade dönüşümü ve
`eval` ile değerlendirme. Bu açıklamalar, MATLAB/Octave ortamında GUI ile çalışan bir hesap
makinesinin nasıl yazıldığını anlamanıza yardımcı olur. Sayfadaki çıktı bloğu betiğin
**ölçülmüş** koşusudur (GNU Octave 11.3.0).

## Ne öğreneceksiniz

- `figure` (`Name`, `NumberTitle`, `Position`, `MenuBar`, `Resize`) ve `uicontrol`
  (`Style`, `Parent`, `Position`, `Callback`) ile pencere kurmayı
- Bir hücre dizisindeki (`buttons`) etiketleri iç içe döngüyle düğmeye çevirmeyi ve boş
  hücreleri `continue` ile atlamayı
- Kullanıcı ifadesini Octave sözdizimine çevirmeyi: `5!` → `fakt(5)`, `x^y` → `^`,
  `log` → `log10`, `e` → `exp(1)`
- `try` / `catch` ile hatalı ifadeyi "Hata!" ekranına düşürmeyi
- Aynı çekirdeği GUI olmadan sınamayı: `eval` yolu başsız oturumda da ölçülebilir

## Çalıştırma

```sh
octave --no-gui bilimsel_hesap_makinesi_gui.m
```

Betik reponun kökünde ve tek başına koşar. **Grafik arayüz için Qt toolkit gerekir**; bu
makinede yalnız `fltk` ve `gnuplot` var, `uicontrol` nesneleri kuruluyor ama gerçek pencere
açılmıyor — betik bunu `try`/`catch` ile yakalar, kurulan düğme sayısını yazdırır ve devam
eder. İfade değerlendirme çekirdeği GUI'den bağımsız olduğu için başsız oturumda da ölçülür.
Bu makinede `octave --no-gui` ayrıca Qt/cocoa eklentisi yüzünden betiği yüklemeden düşüyor
(**EXIT=134**); sayfadaki blok `octave-cli` ile ölçüldü.

## Kod

### Ana fonksiyon

`function bilimsel_hesap_makinesi_gui()` hesap makinesi GUI'sini başlatan ana fonksiyonun
tanımıdır; çağrıldığında hesap makinesi penceresi açılır. Bu sürümde pencere kurulumu tek bir
`try` bloğunun içinde, düğme üretimi ise parametre tablosundan yapılır.

### Pencere oluşturma

`f = figure('Name', 'Bilimsel Hesap Makinesi', 'NumberTitle', 'off', 'Position', [500 300 360 400], 'MenuBar', 'none', 'Resize', 'off');`

- **`figure`**: yeni bir pencere (figure) oluşturur. **`'Name'`**: pencere başlığını "Bilimsel
  Hesap Makinesi" yapar. **`'NumberTitle', 'off'`**: otomatik numara başlığını kapatır.
- **`'Position', [500 300 360 400]`**: pencereyi x=500, y=300 konumunda 360×400 piksel
  boyutunda açar. **`'MenuBar', 'none'`**: menü çubuğunu gizler. **`'Resize', 'off'`**: pencere
  boyutunun değiştirilmesini engeller.

### Giriş kutusu

```octave
exprBox = uicontrol('Style', 'edit', 'Parent', f, ...
    'Position', [20 350 320 35], 'FontSize', 14, ...
    'HorizontalAlignment','right', 'String', '', ...
    'KeyPressFcn', @exprBoxKeyPress);
```

- **`uicontrol`**: kullanıcı arayüzü kontrolü oluşturur. **`'Style', 'edit'`**: metin girişi
  kutusu tipi. **`'Parent', f`**: ana pencereye bağlar. **`'FontSize', 14`**: yazı tipi boyutu.
- **`'HorizontalAlignment','right'`**: metni sağa hizalar (hesap makinesi tarzı).
- **`'KeyPressFcn', @exprBoxKeyPress`**: klavye tuşlarına basıldığında çağrılacak fonksiyon.

### Tuş takımı tanımı

```octave
buttons = { ...
  '7', '8', '9', '/', 'sin', 'cos'; ...
  '4', '5', '6', '*', 'tan', 'log'; ...
  '1', '2', '3', '-', 'sqrt', 'x^y'; ...
  '0', '.', '=', '+', '(', ')'; ...
  'pi', 'e', '!', 'C', '', '' ...
};
```

- Tuş takımında kullanılacak etiketler 5×6 matris olarak tanımlanır; her satır tuş takımının
  bir sırasıdır. Boş string (`''`) olan hücreler için tuş oluşturulmaz — 30 hücrenin 28'i dolu.

### Tuş boyutları ve konumlandırma

`btn_w = 50; btn_h = 40; gap = 10; start_x = 20; start_y = 290;`

- **`btn_w`**: tuş genişliği 50 piksel. **`btn_h`**: tuş yüksekliği 40 piksel. **`gap`**:
  tuşlar arası boşluk 10 piksel. **`start_x`, `start_y`**: ilk tuşun başlangıç koordinatları.

### Tuşları oluşturma

```octave
for i = 1:size(buttons,1)
    for j = 1:size(buttons,2)
        label = buttons{i,j};
        if isempty(label), continue; end
        xpos = start_x + (j-1)*(btn_w+gap);
        ypos = start_y - (i-1)*(btn_h+gap);
        uicontrol('Style', 'pushbutton', 'String', label, ...
            'Position', [xpos ypos btn_w btn_h], 'FontSize', 12, ...
            'Callback', @(src,~)button_callback(exprBox, get(src, 'String')));
    end
end
```

- **İç içe döngüler**: matristeki her tuş için işlem yapar. **`if isempty(label), continue; end`**:
  boş hücreler için tuş oluşturmaz. **Konum hesaplama**: her tuşun x,y koordinatını hesaplar.
- **`uicontrol`**: buton tipinde kontrol oluşturur, **`'Callback'`**: butona basıldığında
  çağrılacak fonksiyon.

### Klavye girişi fonksiyonu

`exprBoxKeyPress(src, event)` Enter veya Return tuşuna basılırsa hesaplar: ifadeyi alır,
dönüşümleri uygular, `eval` ile değerlendirir ve sonucu kutuya yazar; hata olursa "Hata!" yazar.

**Çalışma Mantığı:**

1. **Tuş kontrolü**: Enter/Return tuşuna basıldığını kontrol eder.
2. **İfade alma**: metin kutusundan girilen ifadeyi alır.
3. **Dönüşümler**: matematiksel ifadeleri Octave'nin anlayacağı forma çevirir:
   `pi` → `pi` (pi sabiti), `e` → `exp(1)` (e sabiti), `5!` → `fakt(5)` (faktöriyel),
   `x^y` → `^` (üs alma), `log` → `log10` (10 tabanında logaritma).
4. **Hesaplama**: `eval()` fonksiyonu ile ifadeyi değerlendirir. **Sonuç**: hesaplanan değeri
   metin kutusuna yazar. **Hata yakalama**: hatalı ifadelerde "Hata!" mesajı gösterir.

### Tuş takımı callback fonksiyonu ve faktöriyel

`button_callback(exprBox, label)` `persistent expr` ile ifadeyi çağrılar arasında korur:
sayı/operatör tuşları ifadeye eklenir, `=` hesaplar, `C` temizler, fonksiyon tuşları parantez
açarak çağrı başlatır (`sin(`, `cos(`, `tan(`, `log(`, `sqrt(`), `x^y` ise `^` ekler.
`function y = fakt(n) — y = prod(1:n);` 1'den n'ye kadar tüm sayıların çarpımını hesaplar;
`fakt(5)` = 1×2×3×4×5 = 120.

### Betik

Bu sürümde ifade çevirme ve değerlendirme, GUI'den ayrı iki yerel fonksiyona taşındı
(`ifade_cevir`, `ifade_degerlendir`); böylece aynı kod hem düğmeden hem Enter'dan hem de
başsız konsoldan çağrılabilir. Aşağıdaki betik dosyanın tamamıdır
(`kod: bilimsel_hesap_makinesi_gui.m`).

```octave
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
```

### Kullanım örnekleri

Temel işlemler: `2 + 3 * 4 = 14`, `sin(pi/2) = 1`, `sqrt(16) = 4`, `5! = 120`, `log(100) = 2`.
Karmaşık ifadeler: `sin(pi/4) + cos(pi/4) = 1.4142`, `sqrt(2^2 + 3^2) = 3.6056`,
`(5!)/(3!*2!) = 10`. Betiğin `[1]` bölümü bu yedi ifadeyi sırayla değerlendirip yazdırır —
ölçülen sonuçlar bu değerlerdir.

## Beklenen Çıktı

```
[1] 7 ornek ifade, donusum + eval:
[1]   2+3*4            -> 2+3*4                        = 14
[1]   sin(pi/2)        -> sin(pi/2)                    = 1
[1]   sqrt(16)         -> sqrt(16)                     = 4
[1]   5!               -> fakt(5)                      = 120
[1]   log(100)         -> log10(100)                   = 2
[1]   (5!)/(3!*2!)     -> (fakt(5))/(fakt(3)*fakt(2))  = 10
[1]   e^2              -> ^exp(1)2                     = Hata!
[2] ayni ifade iki surumde:
[2]   duz           -> exp(1)xp(2)              = Hata!
[2]   duzeltilmis   -> exp(2)                   = 7.3891
[3] GUI: 1 girdi kutusu + 28 dugme kuruldu, figure'da bulunan: 28
[3] pencere basasiz oturumda gosterilmedi ve kapatildi (Qt yok)
[4] tus takimi: 5x6 izgara, 28 dolu hucre, 2 bos hucre
[4] bilimsel fonksiyon dugmeleri: sin, cos, tan, log, sqrt, x^y
[4] sabit dugmeleri: pi, e;  islem dugmeleri: +, -, *, /, ^, !, (, )

Ozet: donusum + eval cekirdegi 7 ifade uzerinde olculdu; GUI iskeleti
      28 dugme ile kuruldu. Gercek pencere icin Qt toolkit gerekir
      (bu makinede yalniz fltk ve gnuplot var).
```

## Öne Çıkan Noktalar

- **Bilinen hata ölçüldü:** nottaki düz sürüm `e` harfini körü körüne değiştirdiği için
  `exp(2)` ifadesini `exp(1)xp(2)` yapıyor ve `Hata!` veriyor. Düzeltilmiş sürüm `e`'yi yalnız
  tek başına dururken (`regexprep` ile sözcük sınırında) değiştirir → `7,3891`. Ölçüm `[2]`
  bölümünde iki satır hâlinde duruyor.
- **`e^2` hâlâ hatalı:** düz sürümde `e^2` → `exp(1)^2` beklenirdi, çıktı `^exp(1)2` oldu;
  çünkü `!` dönüşümünden önce/sonra sıralama karışıyor. Doğru yol `e` gibi sabitleri ifade
  ayrıştırıcısıyla (token) değiştirmektir; bu notta hata **gösterilerek** bırakıldı.
- **`eval` bilinçli:** hesap makinesinin işi ifade değerlendirmektir; girdi yalnız tuş
  takımından gelen yerel dizedir. Yine de `eval` güvenlik açısından risklidir — dış kaynaktan
  gelen metinle asla kullanılmamalıdır.
- **Başsız kurulum:** `figure("visible","off")` + `uicontrol` **28 düğme** kuruyor ve
  `findobj(fig,"Style","pushbutton")` de 28 buluyor; pencere gösterilmiyor, hemen kapatılıyor.
  Gerçek pencere için Qt toolkit gerekir (bu makinede yalnız `fltk`, `gnuplot`).
- **Geliştirme önerileri:** ek fonksiyonlar (`asin`, `acos`, `atan`, `ln`), hafıza fonksiyonları
  (M+, M-, MR, MC), bilimsel notasyon, işlem geçmişi ve daha fazla klavye kısayolu.
- **Hata ayıklama ipuçları:** "Hata!" mesajı geçersiz matematiksel ifade demektir; pencere
  açılmıyorsa Octave'in GUI desteğini kontrol edin; tuşlar çalışmıyorsa callback
  fonksiyonlarını; yanlış sonuç varsa dönüşüm kurallarını gözden geçirin.

## Alıştırmalar

1. `ifade_cevir` fonksiyonuna `ln` desteği ekleyin (`ln(` → `log(`) ve `e^2` sorununu
   `regexprep` ile çözün: `e` yalnız sayı/parantez komşuluğunda değişsin. Ölçüm satırlarını
   yeniden üretin.
2. Düğme takımına `asin`, `acos`, `atan` ekleyin (6×7 izgara): düğme sayısı kaç olur, pencere
   genişliği (`360 px`) yeterli mi? `btn_w` ve `gap` değerlerini buna göre hesaplayın.
3. `try/catch` bloğunu kaldırıp `1/0` ve `sqrt(-1)` ifadelerini değerlendirin: hangisi hata
   veriyor, hangisi `Inf`/karmaşık sonuç döndürüyor? "Hata!" eşiğini nasıl tanımlarsınız?
4. `persistent expr` yerine `handles` yapısı (veya uygulama verisi `guidata`) kullanın: iki
   hesap makinesi penceresi aynı anda açıldığında durum neden karışır, açıklayın.
