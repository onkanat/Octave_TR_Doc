---
layout: default
title: "Octave Bilimsel Hesap Makinesi GUI"
---

# Octave Bilimsel Hesap Makinesi GUI – Detaylı Açıklama

Bu dokümanda, `src/bilimsel_hesap_makinesi_gui.m` dosyasındaki kodun satır satır ne işe yaradığını açıklıyoruz. Bu açıklamalar, MATLAB/Octave ortamında GUI ile çalışan bir bilimsel hesap makinesinin nasıl yazıldığını anlamanıza yardımcı olur.

## Projeye Giriş

Bu proje, Octave'de grafik kullanıcı arayüzü (GUI) kullanarak basit ama işlevsel bir bilimsel hesap makinesi oluşturmayı gösterir. Hesap makinesi şu özelliklere sahiptir:

- Temel aritmetik işlemler (+, -, *, /)
- Bilimsel fonksiyonlar (sin, cos, tan, log, sqrt)
- Matematiksel sabitler (pi, e)
- Faktöriyel hesaplama (!)
- Üs alma işlemi (x^y)
- Parantez kullanımı
- Klavye ve fare desteği

## Kod Açıklamaları

### Ana Fonksiyon

```octave
function bilimsel_hesap_makinesi_gui()
```

- Hesap makinesi GUI'sini başlatan ana fonksiyonun tanımıdır.
- Bu fonksiyon çağrıldığında hesap makinesi penceresi açılır.

### Pencere Oluşturma

```octave
f = figure('Name', 'Bilimsel Hesap Makinesi', 'NumberTitle', 'off', ...
           'Position', [500 300 360 400], 'MenuBar', 'none', 'Resize', 'off');
```

- **`figure`**: Yeni bir pencere (figure) oluşturur.
- **`'Name'`**: Pencere başlığını "Bilimsel Hesap Makinesi" olarak ayarlar.
- **`'NumberTitle', 'off'`**: Otomatik numara başlığını kapatır.
- **`'Position', [500 300 360 400]`**: Pencereyi x=500, y=300 konumunda 360x400 piksel boyutunda açar.
- **`'MenuBar', 'none'`**: Menü çubuğunu gizler.
- **`'Resize', 'off'`**: Pencere boyutunun değiştirilmesini engeller.

### Giriş Kutusu

```octave
exprBox = uicontrol('Style', 'edit', 'Parent', f, ...
    'Position', [20 350 320 35], 'FontSize', 14, ...
    'HorizontalAlignment','right', 'String', '', ...
    'KeyPressFcn', @exprBoxKeyPress);
```

- **`uicontrol`**: Kullanıcı arayüz kontrolü oluşturur.
- **`'Style', 'edit'`**: Metin girişi kutusu tipi.
- **`'Parent', f`**: Ana pencereye bağlar.
- **`'Position', [20 350 320 35]`**: Kutunun konumu ve boyutu.
- **`'FontSize', 14`**: Yazı tipi boyutu.
- **`'HorizontalAlignment','right'`**: Metni sağa hizalar (hesap makinesi tarzı).
- **`'String', ''`**: Başlangıç değeri boş.
- **`'KeyPressFcn', @exprBoxKeyPress`**: Klavye tuşlarına basıldığında çağrılacak fonksiyon.

### Tuş Takımı Tanımı

```octave
buttons = { ...
  '7', '8', '9', '/', 'sin', 'cos'; ...
  '4', '5', '6', '*', 'tan', 'log'; ...
  '1', '2', '3', '-', 'sqrt', 'x^y'; ...
  '0', '.', '=', '+', '(', ')'; ...
  'pi', 'e', '!', 'C', '', '' ...
};
```

- Hesap makinesi tuş takımında kullanılacak tuşların etiketleri 5x6 matris olarak tanımlanıyor.
- Her satır tuş takımının bir sırasını temsil eder.
- Boş string ('') olan hücreler tuş oluşturulmaz.

### Tuş Boyutları ve Konumlandırma

```octave
btn_w = 50; btn_h = 40; gap = 10;
start_x = 20; start_y = 290;
```

- **`btn_w = 50`**: Tuş genişliği 50 piksel.
- **`btn_h = 40`**: Tuş yüksekliği 40 piksel.
- **`gap = 10`**: Tuşlar arası boşluk 10 piksel.
- **`start_x = 20, start_y = 290`**: İlk tuşun başlangıç koordinatları.

### Tuşları Oluşturma

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

- **İç içe döngüler**: Matristeki her tuş için işlem yapar.
- **`if isempty(label), continue; end`**: Boş hücreler için tuş oluşturmaz.
- **Konum hesaplama**: Her tuşun x,y koordinatını hesaplar.
- **`uicontrol`**: Buton tipinde kontrol oluşturur.
- **`'Callback'`**: Butona basıldığında çağrılacak fonksiyon.

---

## Fonksiyon Açıklamaları

### Klavye Girişi Fonksiyonu

```octave
function exprBoxKeyPress(src, event)
    % Enter veya Return tuşuna basılırsa hesapla
    if strcmp(event.Key, 'return') || strcmp(event.Key, 'enter')
        expr = get(src, 'String');
        try
            str = expr;
            str = strrep(str, 'pi', 'pi');
            str = strrep(str, 'e', 'exp(1)');
            str = regexprep(str, '(\d+)!', 'fakt($1)');
            str = strrep(str, 'sqrt', 'sqrt');
            str = strrep(str, 'x^y', '^');
            str = strrep(str, 'sin', 'sin');
            str = strrep(str, 'cos', 'cos');
            str = strrep(str, 'tan', 'tan');
            str = strrep(str, 'log', 'log10');
            value = eval(str);
            set(src, 'String', num2str(value));
        catch
            set(src, 'String', 'Hata!');
        end
    end
end
```

**Çalışma Mantığı:**

1. **Tuş kontrolü**: Enter/Return tuşuna basıldığını kontrol eder.
2. **İfade alma**: Metin kutusundan girilen ifadeyi alır.
3. **Dönüşümler**: Matematiksel ifadeleri Octave'nin anlayacağı forma çevirir:
   - `pi` → `pi` (pi sabiti)
   - `e` → `exp(1)` (e sabiti)
   - `5!` → `fakt(5)` (faktöriyel)
   - `x^y` → `^` (üs alma)
   - `log` → `log10` (10 tabanında logaritma)
4. **Hesaplama**: `eval()` fonksiyonu ile ifadeyi değerlendirir.
5. **Sonuç**: Hesaplanan değeri metin kutusuna yazar.
6. **Hata yakalama**: Hatalı ifadelerde "Hata!" mesajı gösterir.

### Tuş Takımı Callback Fonksiyonu

```octave
function button_callback(exprBox, label)
    persistent expr
    if isempty(expr)
        expr = '';
    end

    switch label
        case {'0','1','2','3','4','5','6','7','8','9','+','-','*','/','(',')','.'}
            expr = [expr label];
            set(exprBox, 'String', expr);
        case '='
            try
                str = expr;
                % Dönüşümler (yukarıdaki gibi)
                value = eval(str);
                set(exprBox, 'String', num2str(value));
                expr = num2str(value);
            catch
                set(exprBox, 'String', 'Hata!');
                expr = '';
            end
        case 'C'
            expr = '';
            set(exprBox, 'String', '');
        case 'sin'
            expr = [expr 'sin('];
            set(exprBox, 'String', expr);
        case 'cos'
            expr = [expr 'cos('];
            set(exprBox, 'String', expr);
        case 'tan'
            expr = [expr 'tan('];
            set(exprBox, 'String', expr);
        case 'log'
            expr = [expr 'log('];
            set(exprBox, 'String', expr);
        case 'sqrt'
            expr = [expr 'sqrt('];
            set(exprBox, 'String', expr);
        case 'x^y'
            expr = [expr '^'];
            set(exprBox, 'String', expr);
        case '!'
            expr = [expr '!'];
            set(exprBox, 'String', expr);
        case 'pi'
            expr = [expr 'pi'];
            set(exprBox, 'String', expr);
        case 'e'
            expr = [expr 'e'];
            set(exprBox, 'String', expr);
    end
end
```

**Önemli Özellikler:**

- **`persistent expr`**: Değişken fonksiyon çağrıları arasında korunur.
- **Switch-case yapısı**: Farklı tuş türleri için farklı işlemler.
- **Sayı/operatör tuşları**: Direkt olarak ifadeye eklenir.
- **'=' tuşu**: Hesaplama yapar ve sonucu gösterir.
- **'C' tuşu**: Temizleme işlemi yapar.
- **Fonksiyon tuşları**: Parantez açarak fonksiyon çağrısı başlatır.

### Faktöriyel Fonksiyonu

```octave
function y = fakt(n)
    y = prod(1:n);
end
```

- **`prod(1:n)`**: 1'den n'ye kadar tüm sayıların çarpımını hesaplar.
- **Örnek**: `fakt(5)` = 1×2×3×4×5 = 120

---

## Kullanım Örnekleri

### Temel İşlemler

```octave
% Hesap makinesini başlat
bilimsel_hesap_makinesi_gui()

% Örnekler:
% 2 + 3 * 4 = 14
% sin(pi/2) = 1
% sqrt(16) = 4
% 5! = 120
% log(100) = 2
```

### Karmaşık İfadeler

```octave
% sin(pi/4) + cos(pi/4) = 1.4142
% sqrt(2^2 + 3^2) = 3.6056
% (5!)/(3!*2!) = 10
```

## Geliştirme Önerileri

1. **Ek Fonksiyonlar**: `asin`, `acos`, `atan`, `ln` (doğal logaritma)
2. **Hafıza Fonksiyonları**: M+, M-, MR, MC
3. **Bilimsel Notasyon**: Büyük/küçük sayılar için
4. **Geçmiş**: Son işlemlerin listesi
5. **Klavye Kısayolları**: Daha fazla tuş desteği

## Hata Ayıklama İpuçları

1. **"Hata!" mesajı**: Geçersiz matematiksel ifade
2. **Pencere açılmıyor**: Octave GUI desteğini kontrol edin
3. **Tuşlar çalışmıyor**: Callback fonksiyonlarını kontrol edin
4. **Yanlış sonuçlar**: Dönüşüm kurallarını gözden geçirin

---

## Genel Özet

Bu hesap makinesi projesi şunları öğretir:

- **GUI Oluşturma**: `figure`, `uicontrol` kullanımı
- **Event Handling**: Callback fonksiyonları ve klavye olayları
- **String Manipülasyonu**: `strrep`, `regexprep` kullanımı
- **Hata Yönetimi**: `try-catch` blokları
- **Persistent Değişkenler**: Durum koruma
- **Eval Kullanımı**: Dinamik kod çalıştırma

Bu proje, Octave'de daha karmaşık GUI uygulamaları geliştirmek için sağlam bir temel oluşturur.

---

[Ana Sayfaya Dön](./)
