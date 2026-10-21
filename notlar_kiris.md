---
layout: default
title: "Octave Çalışma Notları: Ortam, Paketler, Yapılar ve Diziler"
lang: tr
konu: ileri
seviye: orta
tur: ders
kod: notlar_kiris.m
redirect_from: [/Octave_Calisma_Notlari.html]
---

# Octave Çalışma Notları: Ortam, Paketler, Yapılar ve Diziler

Bu belge, Octave ile örnek çalışma programları ve notları içermektedir.

Kurulumun neyi desteklediğini ölçmekten paket sorgulamaya, yapı dizilerinden n boyutlu dizilerde dilim almaya kadar
"geliştirici tarifleri". Sayfadaki çıktı bloğu, aynı tarifleri tek betikte toplayan
`notlar_kiris.m` dosyasının **ölçülmüş** koşusudur (GNU Octave 11.3.0).

## Ne öğreneceksiniz

- Bir Octave kurulumunun 64-bit indeksleme, Java, görüntü G/Ç desteğini tek satırlık testlerle
  ölçmeyi (`sizemax`, `usejava`, `imformats`)
- `pkg("list")` ve `pkg("list", "ad")` ile paket varlığını sorgulamayı; hatayı yakalayıp yeniden
  fırlatmanın neden gereksiz olduğunu
- `__builtins__()` + `__list_functions__()` ile tüm çağrılabilir adları listelemeyi
- Yapı dizisinden alan değerlerini virgülle ayrılmış liste olarak çıkarıp `reshape` ile korumayı
- `subsref` + `repelems` ile boyut sayısı bilinmeyen diziden dilim almayı (`array_slice`)

## Çalıştırma

```sh
octave --no-gui notlar_kiris.m
```

Betik reponun kökünde ve tek başına koşar; ek paket yüklemez, dosya yazmaz, grafik çizmez.
Bu makinede `octave --no-gui` Qt/cocoa eklentisi yüzünden betiği yüklemeden düşüyor
(**EXIT=134**); sayfadaki blok aynı çıktıyı veren `octave-cli` ile ölçüldü.

## Kod

Bu notun konusu **programlar, kütüphaneler ve paketler**. Octave program ve kütüphane geliştiricileri için tarifler. Bir Octave programcısının başkaları için kod yazarken bilmesi gereken şeyler. Tariflerin tamamı tek betikte toplandı; her tarifin
kodu aşağıda açıklamasıyla, çalışan birleşik hâli ise betiğin içinde duruyor.

### Octave Yapılandırmasını Bulun

Octave birçok farklı konfigürasyonla oluşturulabildiğinden, programlar ihtiyaç duydukları
özelliklerden yoksun bir makinede çalışabilir. Geliştiriciler, bir Octave kurulumunun tüm
özelliklere sahip olmasını asla beklememelidir. Ayrıca, programlar gerekli özelliklerin mevcut
olup olmadığını tespit etmelidir.

Özellikleri kontrol etmek için kullanılabilecek olası testlerin listesi şu şekildedir:

**64-bit indeksleme desteği:**

```octave
sizemax() > intmax("int32")
```

**Java desteğiyle oluşturulma:**

```octave
usejava("jvm")
```

**Tif dosyaları desteğiyle görüntü G/Ç:**

```octave
any(cellfun(@(x) ismember("tif", x), {imformats.ext}))
```

**Png dosyaları desteğiyle görüntü G/Ç:**

```octave
any(cellfun(@(x) ismember("png", x), {imformats.ext}))
```

Betiğin `[1]` ve `[2]` bölümleri bu dört testi çalıştırır; ilk ikisini sayı olarak, son ikisini
kayıtlı biçim listesiyle birlikte yazdırır.

### Bir Paketin Yüklü Olup Olmadığını Bulun

**Sorun:** Belirli paketlerin kullanılabilirliğine bağlı olarak farklı işlevler kullanan veya
farklı davranan bir programınız var.

**Çözüm:** `pkg("list", "pkg-name")` şu şekilde kullanın:

```octave
if (! isempty(pkg("list", "foo")))
  ## foo paketindeki fonksiyonları kullanın, tercih edilen yol
elseif (! isempty(pkg("list", "bar")))
  ## bar paketindeki fonksiyonları kullanın, çok da iyi değil
else
  ## varsayılan durum
endif
```

**Tartışma:** Tek amacı paketin yokluğunda başarısız olmaksa, bunu kullanmanız önerilmez. Bu
durumda, paketi yüklemeyi deneyin; Octave yeterince bilgilendirici bir hata mesajı verecektir.
Bunu kontrol etmenin tek amacı, bir paket eksikse yapılacak farklı bir şey olup olmadığını
kontrol etmektir. Aynı şey, bir hatayı yakalamak için de geçerlidir `pkg load`. Bir hatayı
yalnızca yakalayıp tekrar fırlatmak için kullanıyorsanız, en baştan hiç yakalamamanız daha iyi
olur.

```octave
%% Bu düzenek hiçbir şey eklemez. 'pkg load' başarısız olursa,
%% kullanıcıya zaten bir hata mesajı verecektir.
try
  pkg load foo;
catch
  error("foo yüklenemedi: %s", lasterr());
end_try_catch

%% Yine hiçbir şey eklemiyor. 'pkg load' başarısızlığı yeterlidir
if (isempty(pkg("list", "foo")))
  error("program: package foo is not installed");
endif
```

Yüklü bir paketin, bir işlevin her zaman kullanılabilir olacağının garantisi olmadığını
unutmayın. Bazı paketler derleme sırasında işlevleri devre dışı bırakabilir veya belirli
işlevlerin belirli çalışma zamanı gereksinimleri olabilir. Betiğin `[3]` bölümü kurulu paketleri
sayar ve `signal`/`statistics` için bu sorguyu ölçer.

### Octave'deki Tüm İşlevleri Listele

Aşağıdaki betiği kullanın (dosya adı `list_func.m`):

```octave
%% Tüm yerleşik (C++) fonksiyonların ve m-dosya fonksiyonlarının listesi
funcs = vertcat(__builtins__(), __list_functions__());

%% Listeyi dosyaya yaz
fid = fopen("all_funcs.tmp", "w");
if (fid == -1)
  error("Geçici dosya all_funcs.tmp açılamıyor. İptal ediliyor...\n");
endif
fprintf(fid, "%s\n", funcs{:});
fclose(fid);
```

Ve komut satırından şu şekilde yürütün: `run-octave -f list_func.m`. Bu notun betiği aynı
listeyi dosyaya yazmadan sayar (`[4]`): ada göre sıralanmış listenin ilk üçü `EDITOR`,
`EXEC_PATH`, `F_DUPFD`'dir.

### Bir Yapı Dizisindeki Tüm Girdilerden Bir Alan Değeri Alın

**Sorun:** Birden fazla alana sahip bir yapı diziniz var ve belirli bir alandaki değere tüm
öğelerden erişmek istiyorsunuz. Örneğin, aşağıdaki durumda tüm hastaların yaşını döndürmek
istiyorsunuz:

```octave
ornekler = struct("hasta",   {"Bob", "Kevin", "Bob", "Andrew"},
                  "yaş",     {45,    52,      45,    23},
                  "protein", {"H2B", "CDK2", "CDK2", "Tip60"},
                  "tüp",     {3,     5,       2,     18}
                 );
```

**Çözüm:** Yapının indekslenmesi virgülle ayrılmış bir liste döndürür, bu yüzden bunları bir
matris oluşturmak için kullanın.

```octave
[ornekler(:).yaş]
```

Ancak bu, verilerin orijinal yapısını korumaz, bunun yerine tüm değerleri tek bir sütunda döndürür. Bunu düzeltmek için `reshape()` kullanın.

```octave
reshape([ornekler(:).yaş], size(ornekler))
```

**Tartışma:** Tüm değerleri virgülle ayrılmış listeler halinde döndürmek, bunlardan istediğinizi
oluşturmanıza olanak tanır. Sayılar bekleniyorsa, bunları köşeli parantez `[]` içine alarak bir
matris oluşturun. Ancak dizeler bekleniyorsa, süslü parantezler `{}` kullanarak kolayca bir
hücre dizisi de oluşturulabilir.

```octave
{ornekler(:).hasta}
```

Ayrıca tüm elemanları döndürmekle sınırlı değilsiniz, diğer alanlardan mantıksal indekslemeyi
kullanarak diğerlerinden değer alabilirsiniz:

```octave
[ornekler([ornekler(:).yaş] > 34).tüp]                    ## 34 yaşından büyük hastalardan alınan tüm örneklerin tüp numaralarını döndür
[ornekler(strcmp({ornekler(:).protein}, "CDK2")).tüp]     ## protein CDK2 için tüm tüp numaralarını döndür
```

Betikte alan adları ASCII karşılıklarıyla (`yas`, `tup`) yazıldı — yapı alanı adında Türkçe
karakter taşınabilir değildir. Değerler aynıdır: yaşlar `[45 52 45 23]`, `34`'ten büyüklerin
tüp numaraları `[3 5 2]`, `CDK2` proteini için `[5 2]`.

### n-Boyutlu Diziden Bir Dilim Seçin

**Sorun:** Rastgele sayıda boyuta sahip bir `A` dizisi için, örneğin ilk sütunu seçin. Bu,
2 boyutluysa `A(:, 1)`, 3 boyutluysa `A(:, 1, :)` vb. olacaktır.

**Çözüm:** Bir olasılık, dinamik olarak oluşturulan `subsref` girdisiyle doğru sayıda boyuta
sahip olmaktır. Bu, bir fonksiyon olarak yazılabilir:

```octave
function [B] = array_slice(A, k, d)
  # A'nın k'ıncı dilimini (satır, sütun...) döndür, d dilimlenecek boyutu belirtiyor
  idx.type = "()";
  idx.subs = repelems({':'}, [1; ndims(A)]);
  idx.subs(d) = k;
  B = subsref(A, idx);
endfunction

% Test Durumları
%!shared A
%! A = rand(2, 3);
%!assert(array_slice(A, 1, 2), A(:, 1))
%! A = rand(2, 3, 4);
%!assert(array_slice(A, 2, 1), A(2, :, :))
%! A = rand(2, 3, 4, 5);
%!assert(array_slice(A, 1, 2), A(:, 1, :, :))
%! A = rand(2, 3, 4, 5, 6);
%!assert(array_slice(A, 2, 3), A(:, :, 2, :, :))
```

Sonuçtan tekil boyutu kaldırmak için `B` üzerinde şunu kullanın:

```octave
B = reshape(B, [size(B)([1:d-1 d+1:end])]);
```

### Betik

Aşağıdaki betik dosyanın tamamıdır (`kod: notlar_kiris.m`). Dört ortam testi `[1]`–`[2]`,
paket sorgusu `[3]`, fonksiyon sayımı `[4]`, yapı dizisi `[5]`, `array_slice` testleri `[6]`
bölümündedir.

```octave
clear; clc; close all;
1;

%% 0. Hazirlik
warning("off", "all");

%% Yerel fonksiyon: n boyutlu diziden dilim secme
function B = array_slice(A, k, d)
  % A'nin d boyutundaki k'inci dilimini dondurur (2B: sutun, 3B: sayfa ...)
  idx.type = "()";
  idx.subs = repelems({":"}, [1; ndims(A)]);
  idx.subs(d) = k;
  B = subsref(A, idx);
end

%% 1. Ortam: 64-bit indeksleme ve Java destegi
printf("[1] sizemax() = %d, intmax(\"int32\") = %d\n", sizemax(), intmax("int32"));
printf("[1] 64-bit indeksleme destegi: %d (1 = var)\n", sizemax() > intmax("int32"));
printf("[1] Java (JVM) destegi       : %d (0 = yok)\n", usejava("jvm"));

%% 2. Goruntu G/C bicimleri
fmts = imformats();
exts = cell(1, numel(fmts));
for i = 1:numel(fmts)
  exts{i} = fmts(i).ext{1};
end
printf("[2] kayitli goruntu bicimi sayisi: %d\n", numel(exts));
printf("[2] bicimler: %s\n", strjoin(exts, ", "));
printf("[2] nottaki tek satirlik kontrol -> png: %d, tif: %d\n", ...
       any(cellfun(@(x) ismember("png", x), {imformats.ext})), ...
       any(cellfun(@(x) ismember("tif", x), {imformats.ext})));

%% 3. Paket sorgulama: pkg("list") ve tek paket kontrolu
p = pkg("list");
adlar = cellfun(@(s) s.name, p, "UniformOutput", false);
printf("[3] kurulu paket sayisi: %d\n", numel(p));
printf("[3] paketler: %s\n", strjoin(adlar, ", "));
for ad = {"signal", "statistics"}
  var_mi = ! isempty(pkg("list", ad{1}));
  printf("[3]   pkg(\"list\", \"%s\") bos mu: %d (%s)\n", ad{1}, isempty(pkg("list", ad{1})), ...
         merge(var_mi, "kurulu", "kurulu degil"));
end

%% 4. Tum fonksiyonlari listeleme
funcs = vertcat(__builtins__(), __list_functions__());
printf("[4] yerlesik + m-dosya fonksiyon sayisi: %d\n", numel(funcs));
printf("[4] ilk uc ad: %s\n", strjoin(funcs(1:3), ", "));

%% 5. Yapi dizisinden alan degerlerini toplama
ornekler = struct("hasta",   {"Bob", "Kevin", "Bob", "Andrew"}, ...
                  "yas",     {45, 52, 45, 23}, ...
                  "protein", {"H2B", "CDK2", "CDK2", "Tip60"}, ...
                  "tup",     {3, 5, 2, 18});
yaslar = [ornekler(:).yas];
printf("[5] yas dizisi            : %s\n", mat2str(yaslar));
printf("[5] reshape ile korunmus  : %s\n", mat2str(reshape(yaslar, size(ornekler))));
printf("[5] hasta adlari (cell)   : %s\n", strjoin({ornekler(:).hasta}, ", "));
printf("[5] yasi 34'ten buyuk tup : %s\n", mat2str([ornekler(yaslar > 34).tup]));
printf("[5] proteini CDK2 olan tup: %s\n", ...
       mat2str([ornekler(strcmp({ornekler(:).protein}, "CDK2")).tup]));

%% 6. n boyutlu diziden dilim: 4 test
A = rand(2, 3);
t1 = isequal(array_slice(A, 1, 2), A(:, 1));
A = rand(2, 3, 4);
t2 = isequal(array_slice(A, 2, 1), A(2, :, :));
A = rand(2, 3, 4, 5);
t3 = isequal(array_slice(A, 1, 2), A(:, 1, :, :));
A = rand(2, 3, 4, 5, 6);
t4 = isequal(array_slice(A, 2, 3), A(:, :, 2, :, :));
printf("[6] array_slice testleri: %d/4 gecti\n", t1 + t2 + t3 + t4);
B = array_slice(rand(2, 3, 4), 2, 1);
printf("[6] tek boyut kaldirma: size(B) = %s -> reshape = %s\n", ...
       mat2str(size(B)), mat2str(size(reshape(B, [size(B)([1:0 2:end])]))));

%% Ozet
printf("\nOzet: ortam %d bit indeksliyor, Java %s, %d paket kurulu, %d fonksiyon\n", ...
       merge(sizemax() > intmax("int32"), 64, 32), ...
       merge(usejava("jvm"), "var", "yok"), numel(p), numel(funcs));
printf("      tanimli. Yapi dizisi ve n boyutlu dilim ayni betikte olculdu.\n");
```

## Beklenen Çıktı

```
[1] sizemax() = 9223372036854775806, intmax("int32") = 2147483647
[1] 64-bit indeksleme destegi: 1 (1 = var)
[1] Java (JVM) destegi       : 0 (0 = yok)
[2] kayitli goruntu bicimi sayisi: 17
[2] bicimler: bmp, cur, gif, ico, jp2, jpg, pbm, pcx, pgm, png, pnm, ppm, ras, tga, tif, xbm, xpm
[2] nottaki tek satirlik kontrol -> png: 1, tif: 1
[3] kurulu paket sayisi: 9
[3] paketler: general, image, control, matgeom, geometry, struct, parallel, datatypes, llms
[3]   pkg("list", "signal") bos mu: 1 (kurulu degil)
[3]   pkg("list", "statistics") bos mu: 1 (kurulu degil)
[4] yerlesik + m-dosya fonksiyon sayisi: 1806
[4] ilk uc ad: EDITOR, EXEC_PATH, F_DUPFD
[5] yas dizisi            : [45 52 45 23]
[5] reshape ile korunmus  : [45 52 45 23]
[5] hasta adlari (cell)   : Bob, Kevin, Bob, Andrew
[5] yasi 34'ten buyuk tup : [3 5 2]
[5] proteini CDK2 olan tup: [5 2]
[6] array_slice testleri: 4/4 gecti
[6] tek boyut kaldirma: size(B) = [1 3 4] -> reshape = [3 4]

Ozet: ortam 64 bit indeksliyor, Java yok, 9 paket kurulu, 1806 fonksiyon
      tanimli. Yapi dizisi ve n boyutlu dilim ayni betikte olculdu.
```

## Öne Çıkan Noktalar

- **Ortam ölçüldü:** `sizemax() = 9223372036854775806` → 64-bit indeksleme var; Java yok
  (`usejava("jvm") = 0`), bu yüzden XML tarifi bu makinede çalışmaz (bkz. Giriş/Çıkış notu).
- **Görüntü biçimi testi iki biçimde yazılır:** `any(cellfun(@(x) ismember("png", x),
  {imformats.ext}))` tek satırda tüm biçimleri tarar; `{imformats.ext}` virgülle ayrılmış
  listeyi hücreye çevirir. Bu ifade `strjoin`'e doğrudan verilemez (hücre içinde hücre olur) —
  bu yüzden betik listeyi ayrıca döngüyle düzleştirir.
- **9 paket kurulu:** `general, image, control, matgeom, geometry, struct, parallel,
  datatypes, llms`. `signal` ve `statistics` **kurulu değil** — bu yüzden Faz 3'teki sinyal
  notunda `butter`/`cheby1` yerine pencerelenmiş sinc kullanıldı (aynı dosyanın gerekçesi).
- **1806 çağrılabilir ad:** `__builtins__()` (C++ yerleşikleri) ile `__list_functions__()`
  (m-dosya fonksiyonları) birleşimi. Liste sürüme bağlıdır; betiğe sayı yazmak yerine saydırmak
  bu yüzden doğru yol.
- **`array_slice` dört testi de geçiyor** (2B, 3B, 4B, 5B). `repelems({":"}, [1; ndims(A)])`
  dilimleme listesini boyut sayısı kadar `':'` ile doldurur; `idx.subs(d) = k` yalnız istenen
  boyutu sabitler.

## Alıştırmalar

1. `pkg("list", "foo")` sorgusunu kurulu bir paket adıyla (`geometry`) tekrarlayın: `isempty`
   sonucu ne oluyor, `pkg load geometry` sonrası `imformats` listesi değişiyor mu?
2. `array_slice` fonksiyonunu tek boyut kaldıracak biçimde genişletin (`squeeze` ile
   karşılaştırın): 2×3×4 dizide `array_slice(A,2,1)` sonucu `1×3×4` mi `3×4` mü olmalı?
3. Yapı dizisine yeni bir hasta ekleyin (`ornekler(end+1) = struct(...)`) ve `[ornekler(:).yas]`
   çıktısının nasıl büyüdüğünü yazdırın. `reshape` neden artık gerekli değil?
4. `list_func.m` betiğini nottan birebir yazıp `run-octave -f list_func.m` ile koşun (bu makinede
   `run-octave` yoksa `octave-cli list_func.m`): `all_funcs.tmp` kaç satır oluyor, `[4]`'te
   ölçülen sayıyla aynı mı?
