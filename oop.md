---
layout: default
title: "Octave'de Nesne Yönelimli Programlama: classdef, Değer ve handle"
lang: tr
konu: ileri
seviye: ileri
tur: ders
kod: oop.m
redirect_from: [/Octave_oop.html]
---

# Octave'de Nesne Yönelimli Programlama: classdef, Değer ve handle

Octave, MATLAB ile uyumlu `classdef` sınıflarını destekler: veriyi (`properties`) ve o veri
üzerinde çalışan işlevleri (`methods`) tek bir türde toplar. Bu not; yapıcı metodu, doğrulama
yapan metotları, hata yakalamayı ve Octave'in en çok karıştırılan noktasını — **değer
semantiği** ile `handle` sınıfının referans semantiği farkını — ölçülmüş bir betikle
gösterir. Sayfadaki çıktı bloğu betiğin **ölçülmüş** koşusundan alınmıştır.

## Ne öğreneceksiniz

- `classdef` ile `properties` ve `methods` bloklarını, sınıfla **aynı adı taşıyan** yapıcı
  metodu tanımlamayı
- Sınıf tanımının neden ayrı bir `.m` dosyasında durması gerektiğini ve betikten nasıl
  yükleneceğini (`addpath`)
- Değer semantiği: `nesne.metot()` çağrısının sonucu **geri atanmazsa** nesnenin
  değişmediğini (ölçüldü: 1300 TL'de kalır)
- `error` ile doğrulama yapmayı ve `try`/`catch` ile hatayı yakalamayı
- `classdef ... < handle` ile referans semantiği elde etmeyi (atama olmadan nesne değişir)

## Çalıştırma

```sh
octave --no-gui oop.m
```

Betik reponun kökünde ve tek başına koşar; paket yüklemez. Octave bir betik dosyasının
içinde `classdef` tanımına izin vermez (`syntax error near line 2`), bu yüzden betik iki
sınıf dosyasını (`BankaHesabi.m`, `BankaHesabiRef.m`) sistemin geçici dizinine yazıp yola
ekler. Sayfadaki blok GNU Octave 11.3.0 ile `octave-cli` üzerinden ölçüldü; bu makinede
`octave --no-gui` Qt/cocoa eklentisi yüzünden betiği yüklemeden düşüyor (EXIT=134).

## Kod

Sınıfın üç parçası:

| Parça | Bu örnekte | Ne yapar |
|---|---|---|
| `properties` | `HesapSahibi`, `Bakiye = 0` | Nesnenin durumu; her nesne kendi kopyasını taşır |
| yapıcı metot | `function obj = BankaHesabi(sahip, baslangic)` | Sınıfla aynı adlı, nesne kurulurken çağrılır |
| `methods` | `paraYatir`, `paraCek`, `goruntule` | Nesne üzerinde işlem yapar, `obj` döndürür |

Aşağıdaki betik dosyanın tamamıdır (`kod: oop.m`):

```octave
clear; clc; close all;

%% 0. Hazirlik: sinif dosyalari gecici dizine yazilir
% Octave'de classdef bir betik dosyasinin icinde tanimlanamaz; sinif, adini
% tasiyan ayri bir .m dosyasinda durur. Betigin tek basina kosmasi icin iki
% sinif dosyasi sistemin gecici dizinine yazilip yola (path) eklenir.
gecici = tempdir();
banka_kaynak = {
  "classdef BankaHesabi"
  "  properties"
  "    HesapSahibi"
  "    Bakiye = 0;   % varsayilan deger"
  "  end"
  "  methods"
  "    function obj = BankaHesabi(sahip, baslangic)"
  "      if nargin > 0"
  "        obj.HesapSahibi = sahip;"
  "        obj.Bakiye = baslangic;"
  "      end"
  "    end"
  "    function obj = paraYatir(obj, miktar)"
  "      if miktar <= 0"
  "        error('Yatirilacak miktar pozitif olmalidir.');"
  "      end"
  "      obj.Bakiye = obj.Bakiye + miktar;"
  "      printf('%.2f TL yatirildi. Yeni bakiye: %.2f TL\\n', miktar, obj.Bakiye);"
  "    end"
  "    function obj = paraCek(obj, miktar)"
  "      if miktar <= 0"
  "        error('Cekilecek miktar pozitif olmalidir.');"
  "      end"
  "      if obj.Bakiye >= miktar"
  "        obj.Bakiye = obj.Bakiye - miktar;"
  "        printf('%.2f TL cekildi. Yeni bakiye: %.2f TL\\n', miktar, obj.Bakiye);"
  "      else"
  "        printf('Yetersiz bakiye! Bakiye: %.2f TL\\n', obj.Bakiye);"
  "      end"
  "    end"
  "    function goruntule(obj)"
  "      printf('Hesap Sahibi: %s, Bakiye: %.2f TL\\n', obj.HesapSahibi, obj.Bakiye);"
  "    end"
  "  end"
  "end"
};
ref_kaynak = {
  "classdef BankaHesabiRef < handle"
  "  properties"
  "    Bakiye = 0;"
  "  end"
  "  methods"
  "    function obj = BankaHesabiRef(baslangic)"
  "      if nargin > 0; obj.Bakiye = baslangic; end"
  "    end"
  "    function yatir(obj, miktar)"
  "      obj.Bakiye = obj.Bakiye + miktar;"
  "    end"
  "  end"
  "end"
};
fid = fopen(fullfile(gecici, "BankaHesabi.m"), "w");
fprintf(fid, "%s\n", banka_kaynak{:});
fclose(fid);
fid = fopen(fullfile(gecici, "BankaHesabiRef.m"), "w");
fprintf(fid, "%s\n", ref_kaynak{:});
fclose(fid);
addpath(gecici);
printf("[0] sinif dosyalari: BankaHesabi.m, BankaHesabiRef.m (tempdir)\n");

%% 1. Nesne olusturma ve yapici metot
ahmet = BankaHesabi("Ahmet Yilmaz", 1000);
ahmet.goruntule();
printf("[1] sinif: %s, BankaHesabi mi: %d\n", class(ahmet), isa(ahmet, "BankaHesabi"));

%% 2. Metotlar: para yatirma ve cekme
ahmet = ahmet.paraYatir(500);
ahmet = ahmet.paraCek(200);
ahmet.goruntule();

%% 3. Deger semantigi: atama olmadan cagrilan metot nesneyi degistirmez
ahmet.paraYatir(100);                 % donus degeri atanmadi
printf("[3] atamasiz cagri sonrasi bakiye: %.2f TL (degismedi)\n", ahmet.Bakiye);
ahmet = ahmet.paraYatir(100);         % dogru kullanim: sonuc geri atanir
printf("[3] atamali cagri sonrasi bakiye : %.2f TL\n", ahmet.Bakiye);

%% 4. Dogrulama ve hata yakalama
try
  ahmet.paraYatir(-50);
catch hata
  printf("[4] hata yakalandi: %s\n", hata.message);
end
ahmet = ahmet.paraCek(5000);          % yetersiz bakiye hatasi vermez, uyarir
printf("[4] yetersiz bakiye sonrasi: %.2f TL\n", ahmet.Bakiye);

%% 5. Yeni nesne ve bagimsizlik
ayse = BankaHesabi("Ayse Kaya", 5000);
ayse = ayse.paraCek(1500);
ayse.goruntule();
printf("[5] iki nesne bagimsiz mi: %d (bakiye farki %.2f TL)\n", ...
       ~isequal(ahmet.Bakiye, ayse.Bakiye), ayse.Bakiye - ahmet.Bakiye);

%% 6. handle sinifi: referans semantigi
ref = BankaHesabiRef(100);
ref.yatir(50);                        % atama YOK, nesne yerinde degisir
printf("[6] handle sinifi  : atamasiz cagri sonrasi bakiye %.2f TL\n", ref.Bakiye);
printf("[6] handle mi       : %d\n", isa(ref, "handle"));

%% Ozet
printf("\nOzet: BankaHesabi (deger sinifi) ve BankaHesabiRef (handle sinifi) uzerinde\n");
printf("      yapici metot, metotlar, dogrulama, hata yakalama ve iki semantik olculdu.\n");
printf("      Ahmet %.2f TL, Ayse %.2f TL, handle nesne %.2f TL.\n", ...
       ahmet.Bakiye, ayse.Bakiye, ref.Bakiye);
```

## Beklenen Çıktı

```
[0] sinif dosyalari: BankaHesabi.m, BankaHesabiRef.m (tempdir)
Hesap Sahibi: Ahmet Yilmaz, Bakiye: 1000.00 TL
[1] sinif: BankaHesabi, BankaHesabi mi: 1
500.00 TL yatirildi. Yeni bakiye: 1500.00 TL
200.00 TL cekildi. Yeni bakiye: 1300.00 TL
Hesap Sahibi: Ahmet Yilmaz, Bakiye: 1300.00 TL
100.00 TL yatirildi. Yeni bakiye: 1400.00 TL
[3] atamasiz cagri sonrasi bakiye: 1300.00 TL (degismedi)
100.00 TL yatirildi. Yeni bakiye: 1400.00 TL
[3] atamali cagri sonrasi bakiye : 1400.00 TL
[4] hata yakalandi: Yatirilacak miktar pozitif olmalidir.
Yetersiz bakiye! Bakiye: 1400.00 TL
[4] yetersiz bakiye sonrasi: 1400.00 TL
1500.00 TL cekildi. Yeni bakiye: 3500.00 TL
Hesap Sahibi: Ayse Kaya, Bakiye: 3500.00 TL
[5] iki nesne bagimsiz mi: 1 (bakiye farki 2100.00 TL)
[6] handle sinifi  : atamasiz cagri sonrasi bakiye 150.00 TL
[6] handle mi       : 1

Ozet: BankaHesabi (deger sinifi) ve BankaHesabiRef (handle sinifi) uzerinde
      yapici metot, metotlar, dogrulama, hata yakalama ve iki semantik olculdu.
      Ahmet 1400.00 TL, Ayse 3500.00 TL, handle nesne 150.00 TL.
```

## Öne Çıkan Noktalar

- **Değer semantiği en çok yapılan hatadır.** `ahmet.paraYatir(100);` satırı 100 TL
  yatırıldığını yazar ama bakiye 1300 TL'de kalır; çünkü metot değiştirilmiş nesneyi
  **döndürür**, çağıran onu geri atamazsa eski nesne yerinde durur. Doğrusu
  `ahmet = ahmet.paraYatir(100);` — sonrasında bakiye 1400 TL olur.
- `handle` sınıfı bu zorunluluğu kaldırır: `BankaHesabiRef < handle` tanımında
  `ref.yatir(50)` atama olmadan çalışır ve bakiye 150 TL olur. Referans semantiği
  gereken durumlarda (paylaşılan durum, geri çağırım) `handle`, değer semantiği
  gereken durumlarda düz `classdef` tercih edilir.
- `properties` bloğunda varsayılan değer atanabilir (`Bakiye = 0;`); yapıcı yalnız
  verilen argümanları yazar (`nargin > 0` denetimi). Böylece `BankaHesabi()` çağrısı da
  geçerli olur.
- Doğrulama `error` ile yapılır ve `try`/`catch` ile yakalanır (`hata.message` okunur).
  Yetersiz bakiye ise hata değil **uyarı** üretir: metot `printf` ile yazar ve nesneyi
  değiştirmeden döndürür — iş kuralı gereği bu bir istisna değil, beklenen durumdur.
- İki nesne birbirinden bağımsızdır: Ahmet 1400 TL, Ayşe 3500 TL; aradaki fark 2100 TL.
  Sınıf tanımı tek, örnekler ayrı durum taşır.

## Alıştırmalar

1. `BankaHesabi` sınıfına `faizUygula(obj, oran)` metodu ekleyin; bakiyeyi `oran` kadar
   artırsın. Değer semantiği yüzünden çağrıyı nasıl yazmanız gerektiğini ölçerek gösterin.
2. `BankaHesabiRef` sınıfına aynı metodu ekleyip iki sınıfın kullanımını karşılaştırın:
   hangisinde `nesne = nesne.metot()` yazmak zorunlu?
3. `Bakiye` özelliğine negatif değer atanmasını engelleyen bir doğrulama ekleyin
   (`properties (SetAccess = private)` ya da `set.Bakiye` metodu). `ahmet.Bakiye = -5`
   denemesinin nasıl reddedildiğini gösterin.
