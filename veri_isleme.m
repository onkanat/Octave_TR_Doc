clear; clc; close all;

%% 0. Hazirlik: ornek veri dosyasi
% Notun konusu dosyadan okuma/yazma oldugu icin betik girdisini kendi uretir.
% Dosyalar repo icine degil, sistemin gecici dizinine yazilir.
gecici_dizin = tempdir();
girdi_dosyasi = fullfile(gecici_dizin, "ornek_veri.txt");
kayit_dosyasi = fullfile(gecici_dizin, "kayit_veri.txt");

M = [3 1 5; 9 2 6; 4 7 8];
save("-ascii", girdi_dosyasi, "M");
printf("Gecici dizine yazilan dosya : ornek_veri.txt (%d deger, %d sutun)\n", ...
       numel(M), columns(M));

%% 1. load: dosyadaki veriyi degiskene al
V = load(girdi_dosyasi);
printf("\n[load] okunan matris boyutu: %d x %d\n", rows(V), columns(V));
disp(V);

%% 2. save: calisma alanindaki degiskeni dosyaya yaz
D = V * 2;
save("-ascii", kayit_dosyasi, "D");
D_geri = load(kayit_dosyasi);
printf("[save] D = V*2 dosyaya yazildi ve geri okundu; ayni mi: %d\n", ...
       isequal(D, D_geri));

%% 3. who / whos: calisma alani envanteri
% Dosya adlari yol (path) tasidigi icin envanterden once temizlenir; boylece
% tablo makineye gore degismez.
clear gecici_dizin girdi_dosyasi kayit_dosyasi;
printf("\n[who] degisken adlari:\n");
who
printf("\n[whos] ad, boyut ve tur:\n");
whos

%% 4. find: kosulu saglayan ogelerin konumu
A = [1 2 3; 4 5 6; 7 8 9];
[satir, sutun] = find(A == 5);
printf("\n[find] A == 5 -> satir %d, sutun %d, dogrusal indeks %d\n", ...
       satir, sutun, find(A == 5));
[s1, s2] = find(A > 6);
printf("[find] A > 6  -> %d oge: satir [%s], sutun [%s]\n", ...
       numel(s1), num2str(s1'), num2str(s2'));

%% 5. sort: siralama
B = [3 1 5; 9 2 6; 4 7 8];
sutun_bazli = sort(B);
tum_ogeler  = sort(B(:))';
printf("\n[sort] sutun bazli artan:\n");
disp(sutun_bazli);
printf("[sort] tum ogeler artan: %s\n", num2str(tum_ogeler));
printf("[sort] azalan (descend): %s\n", num2str(sort(B(:), "descend")'));

%% 6. Mantiksal indeksleme: filtreleme
kosul  = A > 5;
secili = A(kosul);
printf("\n[filtr] A > 5 -> %s (%d oge)\n", num2str(secili'), numel(secili));
printf("[filtr] en buyuk oge A(A == max(A(:))) -> %s\n", ...
       num2str(A(A == max(A(:)))'));

%% 7. unique: tekrarlanan ogeleri at
T = [1 2 3 1 4 5 4 3];
[benzersiz, ilk_yer, esleme] = unique(T);
printf("\n[unique] girdi          : %s\n", num2str(T));
printf("[unique] benzersiz      : %s\n", num2str(benzersiz));
printf("[unique] ilk gorulme    : %s\n", num2str(ilk_yer'));
printf("[unique] esleme (j)     : %s\n", num2str(esleme'));
printf("[unique] tekrar sayisi  : %d\n", numel(T) - numel(benzersiz));

%% Ozet
printf("\nOzet: load/save (2 gecici dosya), who/whos, find, sort, mantiksal\n");
printf("      indeksleme ve unique ayni betikte olculdu.\n");
