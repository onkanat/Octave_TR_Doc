
---
layout: default
title: Octave'de ODE45 ve Newton'un İkinci Yasası
---
## Octave'de ODE45 Fonksiyonu Detaylı Örnek: Newton'ın İkinci Yasası

**Newton'ın İkinci Yasası**, bir cisim üzerinde uygulanan net kuvvetin, o cismin kütlesine ve ivmesine eşit olduğunu belirtir. Bu yasayı matematiksel olarak ifade etmek için aşağıdaki denklem kullanılır:

**F = m * a**

Burada:

* **F**: Cisim üzerinde uygulanan net kuvvet (N)
* **m**: Cismin kütlesi (kg)
* **a**: Cismin ivmesi (m/s²)

Bu denklem, bir cismin hareketini zamanla nasıl değiştirdiğini açıklamak için kullanılabilir. 

**Örnek:**

Bir cisim üzerinde 10 Newtonluk bir kuvvet uygulandığını ve cismin kütlesinin 2 kilogram olduğunu varsayalım. Bu durumda cismin ivmesi ne olacaktır?

Newton'ın İkinci Yasasını kullanarak ivmeyi hesaplayabiliriz:

**a = F / m**

**a = 10 N / 2 kg**

**a = 5 m/s²**

Görüldüğü gibi, 10 Newtonluk bir kuvvet 2 kilogram kütleli bir cismi 5 metre/saniyekare lik bir ivmeyle hızlandırır.

**ODE45 Kullanarak Hareketi Çözme:**

Newton'ın ikinci yasası (`a = F/m`), ikinci dereceden bir diferansiyel denklemdir çünkü ivme, konumun zamana göre ikinci türevidir (`a = d²x/dt²`). `ode45` gibi sayısal çözücüler, birinci dereceden diferansiyel denklem sistemleriyle çalışır. Bu nedenle, ikinci dereceden denklemimizi iki adet birinci dereceden denkleme dönüştürmemiz gerekir:

1.  **Durum Değişkenlerini Tanımlama:**
    *   `y(1)`: Cismin konumu (`x`)
    *   `y(2)`: Cismin hızı (`v` veya `dx/dt`)

2.  **Denklem Sistemini Yazma:**
    *   Konumun türevi hızdır: `dy(1)/dt = y(2)`
    *   Hızın türevi ivmedir: `dy(2)/dt = F/m`

Bu sistem, `ode45` fonksiyonuna verilecek olan diferansiyel denklem fonksiyonunu tanımlar. Fonksiyon, `t` (zaman) ve `y` (durum vektörü: `[konum; hız]`) girdilerini alıp, bu durumların türevlerinden oluşan bir vektör (`[hız; ivme]`) döndürmelidir.

**Örnek Kodu:**

Aşağıdaki kod, bu sistemi `ode45` ile çözer ve sonuçları tek bir grafikte, farklı renkler ve bir lejant (legend) ile gösterir.

```octave
% Cismin kütlesi
m = 2; % kg

% Cisim üzerinde uygulanan kuvvet
F = 10; % N

% Başlangıç koşulları [konum; hız]
y0 = [0; 0]; % [metre; m/s]

% Zaman aralığı
t_eval = 0:0.1:10; % saniye

% Diferansiyel denklem sistemi fonksiyonu
% y(1) -> konum, y(2) -> hız
% dy(1)/dt = y(2)      (hız)
% dy(2)/dt = F/m       (ivme)
newton_ode = @(t, y) [y(2); F/m];

% ODE45 fonksiyonunu kullanarak hareketi çöz
[t, y] = ode45(newton_ode, t_eval, y0);

% Konumu ve hızı tek bir grafikte göster
plot(t, y(:,1), 'b-', 'LineWidth', 2, t, y(:,2), 'r--', 'LineWidth', 2);
grid on;
title("Newton'ın İkinci Yasası: Konum ve Hız");
xlabel('Zaman (s)');
ylabel('Değer');
legend('Konum (m)', 'Hız (m/s)', 'Location', 'northwest');
```

Bu kod, cismin konumunu ve hızını zamanla gösteren iki grafik oluşturacaktır.

**Özet:**

* **ODE45**, birinci dereceden ODE'leri çözmek için kullanılan bir fonksiyondur.
* **ODE45**, y ve dy/dt'nin fonksiyonlarını ve başlangıç koşullarını girdi olarak alır.
* **ODE45**, zamanla y'nin nasıl değiştiğini gösteren bir çözüm verir.
* **ODE45**, Newton'ın İkinci Yasası gibi karmaşık hareket problemlerini çözmek için kullanılabilir.

**Notlar:**

* Bu sadece basit bir örnektir. ODE45 fonksiyonunu daha karmaşık problemlerde de kullanabilirsiniz.
* ODE45 fonksiyonu hakkında daha fazla bilgi için Octave belgelerine bakabilirsiniz: [https://sourceforge.net/projects/octave/](https://sourceforge.net/projects/octave/)

---
[Ana Sayfaya Dön](./)
