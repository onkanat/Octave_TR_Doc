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
