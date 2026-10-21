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
