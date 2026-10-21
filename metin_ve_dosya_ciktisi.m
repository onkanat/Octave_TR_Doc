clear; clc; close all;

%% 1. disp: degeri yazar, degisken adini yazmaz
x = [1 2 3];
printf("[1] x            : ");
disp(x);
printf("[1] log(10)      : ");
log(10)
printf("[1] disp(log(10)): ");
disp(log(10));

format long;
printf("[1] format long sonrasi disp(log(10)): ");
disp(log(10));
format short;

%% 2. disp ciktiyi string olarak dondurur
s = disp(log(10));
printf("\n[2] s turu: %s, karakter sayisi: %d, icerik: %s\n", class(s), numel(s), s);

%% 3. Dosyaya yazma: fopen / fdisp / fclose
% Dosya repo icine degil, sistemin gecici dizinine yazilir.
dosya = fullfile(tempdir(), "metin_cikti_ornek.txt");
fid = fopen(dosya, "w");
A = [1 2 3; 4 5 6];
fdisp(fid, A);
fdisp(fid, "Bu bir test metnidir");
durum = fclose(fid);
printf("\n[3] dosya kapatma durumu: %d (0 = basarili)\n", durum);

%% 4. Yazilan dosyayi geri okuma
icerik = fileread(dosya);
printf("[4] dosya icerigi (%d karakter):\n", numel(icerik));
disp(icerik);

%% 5. printf ailesi: ekran, string, dosya
printf("[5] printf  : ");
printf("Bir tam sayi: %i. Bir gercek sayi: %f. Bu bir %s.\n", 10.1, 5.5, "test");

metin = sprintf("Bir tam sayi: %i. Bir gercek sayi: %f.", 10.1, 5.5);
printf("[5] sprintf : %s (%d karakter)\n", metin, numel(metin));

fid = fopen(dosya, "a");
fprintf(fid, "%s\n", "fprintf ile eklendi");
fclose(fid);
printf("[5] fprintf : dosyanin sonuna eklendi, yeni boyut %d karakter\n", ...
       numel(fileread(dosya)));

%% 6. Format turleri: %i, %f, %e, %%
y = 10.34;
printf("\n[6] %%f -> %f, %%e -> %e (ayni deger)\n", y, y);
printf("[6] %%i -> %i (Octave double'i kirpmaz, degeri yazar)\n", y);
printf("[6] fix ile: %%i -> %i (tam sayiya cevrildi)\n", fix(y));
printf("[6] %%%% -> %i%% (tek yuzde isareti)\n", fix(y));

%% 7. Genislik ve kesinlik
printf("\n[7] %%9i   -> [%9i]\n", 10);
printf("[7] %%9f   -> [%9f]\n", pi);
printf("[7] %%9s   -> [%9s]\n", "test");
printf("[7] %%9.3f -> [%9.3f] (9 sutun, 3 ondalik, yuvarlanir)\n", pi);

%% 8. Matrisi ciktilama: degerler sutun-major sirada okunur
B = [1 2 3; 4 5 6; 7 8 9];
printf("\n[8] printf(\"%%i\\n\", B):\n");
printf("%i\n", B);
printf("[8] printf(\"[%%i, %%.1f, %%.2e]\\n\", B):\n");
printf("[%i, %.1f, %.2e]\n", B);

%% Ozet
printf("\nOzet: disp (format short/long), string donduren disp, fopen-fdisp-fclose\n");
printf("      uclusu, printf/sprintf/fprintf, %%i %%f %%e %%%% turleri, genislik ve\n");
printf("      kesinlik, matris ciktisi ayni betikte olculdu.\n");
