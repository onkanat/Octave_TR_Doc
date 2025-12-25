---
layout: default
title: "Octave'de Nesne Yönelimli Programlama (OOP)"
---

# Octave'de Nesne Yönelimli Programlama (OOP)

Octave, MATLAB ile uyumlu bir şekilde, Nesne Yönelimli Programlama (OOP) yetenekleri sunar. OOP, verileri (özellikler, properties) ve bu veriler üzerinde çalışan fonksiyonları (metotlar, methods) bir araya getiren "nesneler" (objects) oluşturmanıza olanak tanır. Bu, özellikle büyük ve karmaşık programları daha modüler, yeniden kullanılabilir ve yönetilebilir hale getirmek için güçlü bir yaklaşımdır.

Octave'de sınıflar, `classdef` anahtar kelimesi kullanılarak tanımlanır ve genellikle kendi `.m` dosyalarında saklanırlar.

## Sınıflar (`classdef`)

Bir sınıf tanımı, temel olarak üç bölümden oluşur:

    1.  **`properties`**: Nesnenin durumunu veya verilerini tutan değişkenlerdir. Her nesne (o sınıftan oluşturulan her bir örnek), bu özelliklerin kendi kopyasına sahip olur.
    2.  **`methods`**: Sınıfın nesneleri üzerinde işlem yapan fonksiyonlardır. Bu metotlar, nesnenin özelliklerine erişebilir ve onları değiştirebilir.
    3.  **Constructor (Yapıcı Metot)**: Sınıfla aynı isme sahip olan özel bir metottur. Bir sınıftan yeni bir nesne oluşturulduğunda otomatik olarak çağrılır ve genellikle nesnenin başlangıç özelliklerini ayarlamak için kullanılır.

### Örnek: Basit bir "Banka Hesabı" Sınıfı

`BankaHesabi.m` adında bir dosya oluşturalım ve içine aşağıdaki sınıf tanımını yazalım.

```octave
% BankaHesabi.m dosyası
classdef BankaHesabi
    
    properties
        HesapSahibi
        Bakiye = 0; % Varsayılan değer atama
    end
    
    methods
        % Yapıcı Metot (Constructor)
        function obj = BankaHesabi(sahip, baslangicBakiye)
            if nargin > 0 % Eğer argümanlar verilmişse
                obj.HesapSahibi = sahip;
                obj.Bakiye = baslangicBakiye;
            end
        end
        
        % Para Yatırma Metodu
        function obj = paraYatir(obj, miktar)
            if miktar > 0
                obj.Bakiye = obj.Bakiye + miktar;
                fprintf('%.2f TL yatırıldı. Yeni bakiye: %.2f TL\n', miktar, obj.Bakiye);
            else
                error('Yatırılacak miktar pozitif olmalıdır.');
            end
        end
        
        % Para Çekme Metodu
        function obj = paraCek(obj, miktar)
            if miktar <= 0
                error('Çekilecek miktar pozitif olmalıdır.');
            end
            
            if obj.Bakiye >= miktar
                obj.Bakiye = obj.Bakiye - miktar;
                fprintf('%.2f TL çekildi. Yeni bakiye: %.2f TL\n', miktar, obj.Bakiye);
            else
                disp('Yetersiz bakiye!');
            end
        end
        
        % Bakiye Görüntüleme Metodu
        function goruntule(obj)
            fprintf('Hesap Sahibi: %s, Bakiye: %.2f TL\n', obj.HesapSahibi, obj.Bakiye);
        end
    end
    
end
```

### Sınıfı Kullanma

Bu sınıfı kullanmak için, Octave komut satırından veya başka bir script dosyasından `BankaHesabi` nesneleri oluşturabilir ve metotlarını çağırabiliriz.

```octave
% Ahmet'in hesabını oluştur
ahmet_hesap = BankaHesabi('Ahmet Yılmaz', 1000);
ahmet_hesap.goruntule();

% Para yatır
ahmet_hesap = ahmet_hesap.paraYatir(500);

% Para çek
ahmet_hesap = ahmet_hesap.paraCek(200);

% Tekrar görüntüle
ahmet_hesap.goruntule();

% Yetersiz bakiye denemesi
ahmet_hesap = ahmet_hesap.paraCek(2000);

fprintf('\n--------------------\n');

% Ayşe'nin hesabını oluştur
ayse_hesap = BankaHesabi('Ayşe Kaya', 5000);
ayse_hesap.goruntule();
ayse_hesap = ayse_hesap.paraCek(1500);
```

**Önemli Not:** Octave'de (MATLAB'ın eski sürümleri gibi), sınıf metotları nesneyi değer olarak alır (pass-by-value). Bu, bir metot nesnenin bir özelliğini değiştirdiğinde, değişikliğin etkili olması için metodun değiştirilmiş nesneyi bir çıktı argümanı olarak döndürmesi ve çağıranın bu yeni nesneyi orijinal değişkene ataması gerektiği anlamına gelir (`ahmet_hesap = ahmet_hesap.paraYatir(500);` gibi). Daha modern OOP dillerinde bu genellikle referans ile yapılır ve bu atama gerekmez. Octave'de `handle` sınıfları kullanarak referans semantiği elde edilebilir, ancak bu daha ileri bir konudur.

---
[Ana Sayfaya Dön](./)
