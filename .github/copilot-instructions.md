# Copilot talimatları (Octave_TR_Doc)

## Proje özeti
- Bu depo, **Türkçe GNU Octave dokümantasyonu**nu barındırır ve **Jekyll** ile GitHub Pages’e yayınlanan statik bir site üretir.
- İçerik çoğunlukla depo kökündeki konu dosyalarıdır: `Octave_*.md`.
- Ana içerik yönlendirmesi `index.md` içindedir; yeni sayfa eklediğinde buraya link eklemek beklenir.
- İçerik kapsamını büyütürken `.github/roadmap-prompt.md` içindeki yol haritasıyla uyumu kontrol et.

## Yerel geliştirme (Jekyll)
- Ruby/Bundler bağımlılıkları `Gemfile` (özellikle `github-pages`) ile yönetilir.
- Yerel sunucu:
  - VS Code görevi: `.vscode/tasks.json` → **“Jekyll Yerel Sunucu Başlat”**
  - Eşdeğer komut: `bundle exec jekyll serve`
- Jekyll yapılandırması: `_config.yml` (özellikle `baseurl: "/Octave_TR_Doc"`, `theme: jekyll-theme-minimal`). `_site/` repoya eklenmez (bkz. `.gitignore`).

## Markdown sayfa şablonu ve biçim
- Çoğu içerik sayfası YAML front matter kullanır (örnek: `Octave_hizli_baslangic.md`):
  - `layout: default`
  - `title: "..."`
- Sayfa sonlarında genellikle geri dönüş linki bulunur: `[Ana Sayfaya Dön](./)`; yeni sayfalarda bu deseni koru.
- Sayfalar arası linkler dosya adına göre göreli verilir (ör. `Octave_hizli_baslangic.md`).

## Kod blokları (Octave) ve vurgulama
- Octave örnekleri için çitli kod bloğunda dil etiketi **`octave`** kullanılır:
  - ```octave
  - ...
- `_includes/head-custom.html`, tarayıcı tarafında highlight.js ile `language-octave` sınıfını `language-matlab` olarak eşleyerek renklendirme yapar; bu nedenle `octave` etiketini korumak önemlidir.

## Örnek kod dosyaları (.m)
- Bazı anlatım sayfaları gerçek `.m` dosyalarına referans verir (örn. `Octave_bilimsel_hesap_makinesi_gui.md` ↔ `bilimsel_hesap_makinesi_gui.m`). Kod değiştiriyorsan, ilgili doküman bölümünü de senkron güncelle.
- `venn_script.m` içinde `print -dpng /Users/...` gibi **mutlak yol** kullanımı tarihsel (çıktıyı kaydetmek için alınmış eski bir karar). Bu yolu "düzeltme" gereği yok; yeni örneklerde mümkünse depo içi göreli yolları (`assets/img/...`) tercih et.
  - Eğer `venn_script.m` yolunu/çıktısını değiştirirsen, görselin repo referansını da kontrol et: `assets/img/venn_diagram.png` ve doküman sayfası `Octave_venn_diagrami.md`.

## CI/Yayın
- Yayın süreci GitHub Actions ile yapılır: `.github/workflows/jekyll-gh-pages.yml`.
- Değişikliklerin site çıktısına etkisini anlamak için çoğunlukla yerelde Jekyll sunucusunu çalıştırmak yeterlidir.
