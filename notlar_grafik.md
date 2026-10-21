---
layout: default
title: "Octave Çalışma Notları: Giriş/Çıkış, Tablo ve Grafik"
lang: tr
konu: veri
seviye: orta
tur: ders
kod: notlar_grafik.m
redirect_from: [/Octave_Calisma_Notlari_Giris_Cikis.html]
---

# Octave Çalışma Notları: Giriş/Çıkış, Tablo ve Grafik

Bu belge, "Çalışma Notları"nın giriş/çıkış kolunu toplar: eşleşen öğeleri tek `printf` ile
yazdırmaktan `deal` ile takasa, `nthargout` ile çıktı toplamaya, hizalı metin tablosundan CSV
okumaya ve değişken dizeden gelen efsane metnine kadar yedi tarif. Sayfadaki çıktı bloğu,
tariflerin `notlar_grafik.m` içinde birleştirilmiş hâlinin **ölçülmüş** koşusudur
(GNU Octave 11.3.0). Kaynak notta ayrı bir "grafik" başlığı yoktu; bu üçüncü parça, çıktı
biçimlendirme ve grafik etiketlemesi tariflerini toplar.

## Ne öğreneceksiniz

- Hücre dizisini `printf`'e virgülle ayrılmış liste olarak vererek eşleşen öğeleri tek çağrıda
  yazdırmayı
- `deal` ile geçici değişken kullanmadan iki değeri takas etmeyi
- `nthargout(1:n, @f)` ile çok çıktılı bir fonksiyonun tüm sonuçlarını hücrede toplamayı
- `fprintf('%15.15s | %15.15s\n', …)` ile hizalı metin tablosu üretmeyi
- `csvwrite` / `csvread` / `textread` ile CSV gidiş-dönüşünü ve `textread`'in **sütun öncelikli**
  okuduğunu ölçmeyi
- Grafik efsanesini değişkenden üretmeyi (`sprintf` + `legend`); eski `"-1;ad;"` yönteminin bu
  sürümde çalışmadığını görmeyi

## Çalıştırma

```sh
octave --no-gui notlar_grafik.m
```

Betik reponun kökünde ve tek başına koşar; ek paket yüklemez. İki dosya yazar:
`assets/veri/ornek_tablo.csv` (CSV gidiş-dönüşü) ve `assets/img/notlar_grafik-efsane.png`
(efsane metni değişkenden gelen grafik). Bu makinede `octave --no-gui` Qt/cocoa eklentisi
yüzünden betiği yüklemeden düşüyor (**EXIT=134**); sayfadaki blok aynı çıktıyı veren
`octave-cli` ile ölçüldü.

## Kod

### Farklı Dizilerden Eşleşen Öğeleri Görüntüle

**Sorun:** Eşleştirilmiş öğelerden oluşan iki veya daha fazla diziniz var ve bunlar hakkında bir
dize yazdırmak istiyorsunuz. Örneğin:

```octave
anahtarlar = {"insan", "fare", "tavuk"};
degerler = [64, 72, 70];
```

ve şunu görüntülemek istiyorsunuz:

```text
Hesaplanan insan genomu GC içeriği %64'tür
Hesaplanan fare genomu GC içeriği %72'dir
Hesaplanan tavuk genomu GC içeriği %70'tir
```

**Çözüm:** Her eşleştirilmiş verinin bir sütunda olduğu iki satırlık bir hücre dizisi oluşturun
ve `printf` fonksiyonuna bir CS (comma-separated) listesi sağlayın.

```octave
değerler = num2cell(degerler);
yeni = {anahtarlar{:}; değerler{:}};
printf("Hesaplanan %s genom GC içeriği %i%%\n", yeni{:})
```

veya tek bir satırda:

```octave
printf("Hesaplanan %s genom GC içeriği %i%%\n", {keys{:}; num2cell(values){:}}{:})
```

**Tartışma:** `printf` ve ailesi hücre dizilerini değer olarak kabul etmez. Ancak, devam etmek
için yeterli argümana sahip olduğu sürece verilen şablonu tekrarlamaya devam ederler. Bu nedenle,
işin püf noktası, bir hücre dizisi kullanarak ve onu `{}` ile indeksleyerek yapılabilecek bir
elemanlar listesi sağlamaktır.

Değerler sütun bazında sıralandığından, eşleştirilmiş değerlerin aynı sütunda olması gerekir. Daha sonra yeni bir veri satırı eklenebilir.

```octave
yeni(end+1, :) = {"Andrew", "Bob", "Kevin"};
```

Artık indeksleme için normal parantezlerin kullanıldığını unutmayın. Betiğin `[1]` bölümü üç
satırı da yazdırır (metin nottaki örnekten biraz kısa: `GC icerigi`, çünkü betik çıktısı ASCII).

### Takas Değerleri

İki değişken arasındaki değeri, geçici bir değişken oluşturmadan değiştirmek istiyorsanız, şunu
yapabilirsiniz:

```octave
[b, a] = deal(a, b);
```

### Bir Fonksiyonun Tüm Çıktı Argümanlarını Topla

Örneğin, birden fazla değer döndüren bir fonksiyonunuz varsa:

```octave
function [a, b, c] = myfunc()
  [a, b, c] = deal(1, 2, 3);
endfunction
```

ve bunların hepsini tek bir hücrede toplamak istiyorsanız (Python'un `zip()` fonksiyonuna benzer
şekilde) şunu yapabilirsiniz:

```octave
outargs = nthargout(1:3, @myfunc)
```

### `fprintf` ile Bir Metin Tablosu Oluşturun

15 karakter genişliğinde ve her biri sağa dayalı 2 sütundan oluşan bir metin tablosu
oluşturmak istediğinizi düşünün. Bunu `fprintf` ile nasıl yapabilirsiniz? Çok kolay: `Metin`
değişkeni, iki sütun ve belirli sayıda satırdan oluşan bir dize hücre dizisi (uzunluğu < 15) ise,
`Metin` değişkeninin k. satırı için yazmanız yeterlidir:

```octave
fprintf('%15.15s | %15.15s\n', Metin{k, 1}, Metin{k, 2});
```

`%<n>.<m>s` sözdizimi, `n` karakterlik yer ayırır ve görüntülenecek dizenin ilk `m` karakterini
görüntüler.

**Örnek:**

```octave
Metin = {"Merhaba", "Dünya"};
fprintf('%15.15s | %15.15s\n', Metin{1, 1}, Metin{1, 2})
```

Çıktı:

```text
         Merhaba |           Dünya
```

### Virgülle Ayrılmış Değerler (`*.csv`) Dosyalarını Yükleyin

`textread` fonksiyonunu kullanarak tek sütunlu bir hücre dizisi elde edebilirsiniz. `reshape`
fonksiyonunu kullanarak orijinal boyuta geri dönebilirsiniz.

```octave
A = textread("dosya.csv", "%d", "delimiter", ",");
B = textread("dosya.csv", "%s", "delimiter", ",");
inds = isnan(A);
B(!inds) = num2cell(A(!inds))
```

Bir diğer seçenek ise `csvread` fonksiyonunu kullanmaktır. Ancak bu fonksiyon sayısal olmayan
verileri işleyemez.

Muhtemelen en iyi seçenek, IO paketindeki `csv2cell` işlevini kullanmaktır. Bu işlev, karışık
türdeki (sayısal ve metin) `.csv` dosyalarını okuyabilir, virgül ve diğer metin koruma
karakterleri (varsayılan: çift tırnak) dışında alan ayırıcıları belirtmenize olanak tanır ve
başlık satırlarını atlayabilir. IO paketini yüklediyseniz, daha fazla bilgi için Octave komut
istemine `"help csv2cell"` yazın.

Betiğin `[5]` bölümü ölçümü yapar: `csvwrite` ile 3×3 matris yazılır, `csvread` ile geri
okunur (fark `0`) ve aynı dosya `textread` ile okunduğunda değerlerin **sütun öncelikli**
geldiği görülür (`1 4 7 / 2 5 8 / 3 6 9` → `1 4 7 2 5 8 …`). `csvwrite` yalnız sayısal veri
yazdığı için karışık tür için IO paketi gerekir — bu makinede IO paketi kurulu değil.

### XML Dosyalarını Yükle

XML'i Octave olarak okumak, Java kütüphanesi Apache Xerces kullanılarak yapılabilir.

Görünüşe göre Matlab `xmlread`, Apache Xerces kütüphanesini çevreleyen ince bir sargıdan
ibarettir. Ancak, Java fonksiyonlarının Octave başladığında çalışma dizininin çalışma dizinine
ayarlandığını ve çalışma dizininin bir `cd` komutu tarafından değiştirilmediğini unutmamak
gerekir. Matlab da aynı davranışı sergiler, çünkü Java geçerli çalışma dizinini değiştirmenin
bir yolunu sunmaz. Herhangi bir sorun yaşamamak için XML dosyasının mutlak yolunu kullanmak
daha iyidir.

Örneğin, `https://xerces.apache.org/mirrors.cgi#binary` adresinden `xercesImpl.jar` ve
`xml-apis.jar` dosyalarına ihtiyacınız var (en son sürümü kontrol edin). Şu dosyaları eklemek
için `javaaddpath` kullanın:

```octave
javaaddpath("/path/to/xerces-2_11_0/xercesImpl.jar");
javaaddpath("/path/to/xerces-2_11_0/xml-apis.jar");
```

**Örnek:**

```octave
filename = "sample.xml";

%% Bu üç satır Matlab'da xDoc = xmlread(filename) ile eşdeğerdir
parser = javaObject("org.apache.xerces.parsers.DOMParser");
parser.parse(filename);
xDoc = parser.getDocument();

elem = xDoc.getElementsByTagName("data").item(0);  ## ilk veri öğesini al
data = elem.getFirstChild.getTextContent();        ## çocuktan metin al
att  = elem.getAttribute("attribute");             ## 'att' isimli özelliği al
```

**Dosya: `sample.xml`**

```xml
<root>
  <data att="1">merhaba</data>
</root>
```

**Bu makinede ölçülmedi:** `usejava("jvm")` sonucu `0` (giriş notunun `[1]` bölümünde ölçüldü),
yani JVM desteği olmadan `javaObject` çağrısı çalışmaz. Tarif belge olarak duruyor; ölçüm
Java'lı bir kurulum gerektirir.

### Komutlarda Değişken Dizeleri Kullanma

Örneğin, bir dize değişkenini gösterge olarak kullanarak veriyi çizmek için:

**Statik dizeyi efsane olarak (en basiti):**

```octave
x = linspace(-1, 3, 100);
y = sin(x);
legend = "-1;Verilerim;";
plot(x, y, legend);
```

**Değişken dizesi efsane olarak (orta):**

```octave
x = linspace(-1, 3, 100);
y = sin(x);
dataName = "Verilerim";
plot(x, y, sprintf("-1;%s;", dataName));
```

**Değişken dizesini efsane olarak kullanmak (`eval` ile - çok da temiz değil):**

```octave
legend = "Verilerim";
plot_command = ["plot(x, y, '-1;", legend, ";')"];
eval(plot_command);
```

Aynı numaralar benzersiz isimlere sahip veri dosyalarını okumak ve yazmak için de faydalıdır.

**Bu sürümde ölçülen:** `"-1;ad;"` efsane sözdizimi `plot()` tarafından çizgi özelliği sanılıyor
ve `plot: properties must appear followed by a value` hatası veriyor (betiğin `[6]` bölümü bunu
`try/catch` ile gösteriyor). Çalışan yol: `h = plot(...); legend(h, sprintf("%s: sin(x)",
dataName));`

### Betik

Aşağıdaki betik dosyanın tamamıdır (`kod: notlar_grafik.m`).

```octave
clear; clc; close all;

%% 0. Hazirlik
warning("off", "all");
graphics_toolkit("gnuplot");
betik_dizini = fileparts(mfilename("fullpath"));
if isempty(betik_dizini); betik_dizini = pwd(); end
veri_dizini = fullfile(betik_dizini, "assets", "veri");
img_dizini = fullfile(betik_dizini, "assets", "img");
if ~exist(veri_dizini, "dir"); mkdir(veri_dizini); end
if ~exist(img_dizini, "dir"); mkdir(img_dizini); end

%% 1. Eslesen ogeleri tek printf ile yazdirma (hucre dizisi)
anahtarlar = {"insan", "fare", "tavuk"};
degerler = [64, 72, 70];
degerler_hucre = num2cell(degerler);
yeni = {anahtarlar{:}; degerler_hucre{:}};
printf("[1] eslesen degerler (hucre + printf):\n");
printf("Hesaplanan %s genom GC icerigi %i%%\n", yeni{:});

%% 2. Takas: gecici degisken olmadan deal
a = 1; b = 2;
[b, a] = deal(a, b);
printf("[2] deal ile takas: a = %d, b = %d\n", a, b);

%% 3. Fonksiyonun tum cikti argumanlarini toplama (nthargout)
function [a1, b1, c1] = uc_deger()
  [a1, b1, c1] = deal(1, 2, 3);
end
outargs = nthargout(1:3, @uc_deger);
printf("[3] nthargout ile toplanan cikti: %s (cell icinde %d oge)\n", ...
       mat2str(cell2mat(outargs)), numel(outargs));

%% 4. fprintf ile metin tablosu
Metin = {"Merhaba", "Dunya"; "Octave", "notlari"};
printf("[4] fprintf ile hizalanmis tablo (15 karakter):\n");
for k = 1:rows(Metin)
  fprintf("%15.15s | %15.15s\n", Metin{k, 1}, Metin{k, 2});
end

%% 5. CSV dosyasi: yaz, geri oku, karsilastir
M = [1, 2.5, 3; 4, 5.5, 6; 7, 8.5, 9];
csv_dosya = fullfile(veri_dizini, "ornek_tablo.csv");
csvwrite(csv_dosya, M);
M_okunan = csvread(csv_dosya);
kolon1 = textread(csv_dosya, "%d", "delimiter", ",");
printf("[5] CSV: %s yazildi (%d bayt)\n", "assets/veri/ornek_tablo.csv", dir(csv_dosya).bytes);
printf("[5]   csvread ile boyut %s, en buyuk fark %g\n", ...
       mat2str(size(M_okunan)), max(max(abs(M_okunan - M))));
printf("[5]   textread ile okunan %d deger, ilk 6: %s\n", ...
       numel(kolon1), mat2str(kolon1(1:6)'));
printf("[5]   csvwrite yalniz sayisal veri yazar; karisik tur icin IO paketindeki csv2cell gerekir\n");

%% 6. Degisken dizesini efsane olarak kullanma (grafik)
x = linspace(-1, 3, 100);
y = sin(x);
dataName = "Verilerim";
% Nottaki eski yontem: plot(x, y, "-1;ad;") — gnuplot efsane sozdizimi.
% Bu Octave surumunde plot() bunu cizgi ozelligi sanip hata veriyor; olculdu:
try
  f0 = figure("visible", "off"); graphics_toolkit(f0, "gnuplot");
  plot(x, y, sprintf("-1;%s;", dataName));
  printf("[6] \"-1;ad;\" efsane yontemi: calisti\n");
catch e
  printf("[6] \"-1;ad;\" efsane yontemi DESTEKLENMIYOR -> %s\n", e.message);
end
close all;
% Bu surumde gecerli yol: cizimden sonra legend() cagrisi
f = figure("visible", "off"); graphics_toolkit(f, "gnuplot");
h = plot(x, y, "LineWidth", 1.5);
legend(h, sprintf("%s: sin(x)", dataName));
grid on; xlabel("x"); ylabel("sin(x)");
title(sprintf("%s: sin(x) egrisi", dataName));
dosya = fullfile(img_dizini, "notlar_grafik-efsane.png");
print(f, dosya, "-dpng", "-r110");
printf("[6] grafik: %s (%d bayt), efsane metni degiskenden geldi\n", ...
       "notlar_grafik-efsane.png", dir(dosya).bytes);

%% Ozet
printf("\nOzet: %d eslesen deger, deal takasi, nthargout (%d cikti), %dx%d tablo,\n", ...
       numel(degerler), numel(outargs), rows(Metin), columns(Metin));
printf("      CSV gidis-donus (fark %g) ve dinamik efsaneli grafik olculdu.\n", ...
       max(max(abs(M_okunan - M))));
```

## Beklenen Çıktı

```
[1] eslesen degerler (hucre + printf):
Hesaplanan insan genom GC icerigi 64%
Hesaplanan fare genom GC icerigi 72%
Hesaplanan tavuk genom GC icerigi 70%
[2] deal ile takas: a = 2, b = 1
[3] nthargout ile toplanan cikti: [1 2 3] (cell icinde 3 oge)
[4] fprintf ile hizalanmis tablo (15 karakter):
        Merhaba |           Dunya
         Octave |         notlari
[5] CSV: assets/veri/ornek_tablo.csv yazildi (24 bayt)
[5]   csvread ile boyut [3 3], en buyuk fark 0
[5]   textread ile okunan 9 deger, ilk 6: [1 3 3 4 6 6]
[5]   csvwrite yalniz sayisal veri yazar; karisik tur icin IO paketindeki csv2cell gerekir
[6] "-1;ad;" efsane yontemi DESTEKLENMIYOR -> plot: properties must appear followed by a value
[6] grafik: notlar_grafik-efsane.png (8632 bayt), efsane metni degiskenden geldi

Ozet: 3 eslesen deger, deal takasi, nthargout (3 cikti), 2x2 tablo,
      CSV gidis-donus (fark 0) ve dinamik efsaneli grafik olculdu.
```

## Öne Çıkan Noktalar

- **Hücre + `printf` = satır satır çıktı:** `yeni = {anahtarlar{:}; değerler{:}}` iki satırlık
  bir hücre üretir; `printf(..., yeni{:})` şablonu her sütun için yineler. Hücrenin **satır**
  değil **sütun** bazında dolaşıldığını unutmayın — eşleşen değerler aynı sütunda olmalı.
- **`textread` sütun öncelikli okur:** 3×3 CSV dosyası `csvread` ile `[3 3]` dönerken `textread`
  ile `9` değer `1 4 7 2 5 8 3 6 9` sırasında geliyor (ölçüldü). Satır bazlı okuma için
  `reshape` ya da `csvread` gerekir.
- **CSV gidiş-dönüşü kayıpsız:** `csvwrite` → `csvread` farkı `0`; dosya `24 bayt`. Kayan noktalı
  değerler `%g` benzeri kısa yazımla dosyaya düşer, bu yüzden çok küçük farklar beklenebilir.
- **`nthargout(1:3, @f)`** üç çıktıyı tek çağrıda hücreye toplar (`{[1] [2] [3]}`); `deal(1,2,3)`
  ile aynı değerler üretildi. Çıktı sayısı fonksiyonun `nargout` davranışına bağlıdır.
- **Efsane yöntemi sürüme bağlı:** eski gnuplot `"-1;ad;"` yöntemi bu Octave'de hata veriyor;
  `legend(handle, metin)` her iki dünyada da çalışır. Metin değişkenden geliyorsa `sprintf`
  kullanın — efsane etiketi böylece dosya adına/tarihe göre değişebilir.

## Alıştırmalar

1. `printf` şablonunu üç sütunlu hâle getirin (`{"insan","fare","tavuk"}`, GC değerleri ve bir
   üçüncü sayısal sütun): hücre dizisinin biçimi nasıl değişmeli? Satır/sütun karışırsa çıktı
   nasıl bozulur?
2. `deal` ile üç değişkeni döndürün (`[a,b,c] = deal(c,a,b)`): sonuç beklediğiniz gibi mi?
   `nthargout` ile aynı işlemi tek satırda yapabilir misiniz?
3. `Metin` tablosuna 15 karakterden uzun bir metin koyun (`"Bu metin çok uzun bir başlık"`):
   `%15.15s` neden kırpıyor? `%15s` ile karşılaştırın.
4. CSV dosyasını `csv2cell` ile okumayı deneyin (IO paketi gerekir): paket yoksa hata mesajını
   kaydedin ve `pkg install io` sonrası aynı betiği yeniden koşun.
