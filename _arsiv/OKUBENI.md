# Arşiv — Neden burada, neyin yerine?

**Tarih:** 21.10.2026 (Faz 5) · **Kural:** silme yok; taşıma `git mv`/`mv` ile, geri dönüş `git mv` ile aynı yoldan yapılabilir.
Jekyll `_` ile başlayan dizinleri yayınlamaz → bu klasör siteye **çıkmaz** (ölü bağ üretmez).

## 1. `kod-eski/src/` — eski `src/` klasörü (10 dosya)

Bu dosyalar 2025'te notların içine dağılmış **tamamlanmamış parçalar**dı; her biri artık ilgili notun
tek başına koşan `<slug>.m` betiğine derlenmiş durumda (kod kaybı yok, işlev notlarda yaşıyor).

| Dosya (eski yol) | Ne yapıyordu | Bugünkü karşılığı |
|---|---|---|
| `src/two_point_line.m` | iki noktadan doğru denklemi | `fonksiyon_ornekleri.m` (yerel fonksiyon) |
| `src/circle_center.m` | üç noktadan çember merkezi/yarıçapı | `fonksiyon_ornekleri.m`, `venn_diagrami.m` |
| `src/check_intersection.m` | çember–doğru kesişim durumu | `fonksiyon_ornekleri.m` |
| `src/visualize_intersection.m` | yukarıdaki üçünü çizerek gösteren demo | `fonksiyon_ornekleri.m` ([5] grafik) |
| `src/filitre_pasif.m` | pasif RC/LR filtre katsayıları | `power_supply.m` |
| `src/hesapla_gerilme.m` | eğilme gerilmesi hesabı | `muhendislik_alistirmalari.m` |
| `src/test.m` | `input()` ile moment/mesafe soran yarım betik (etkileşimli) | `muhendislik_alistirmalari.m` (girdi betiğin içinde) |
| `src/test_gui.m` | `load('test.m')` ile GUI açan 9 satırlık deneme | `bilimsel_hesap_makinesi_gui.m` |
| `src/power_supply.m` | kökteki `power_supply.m`'nin **eski kopyası** (satır sonu boşluklu, 39 satır) | `power_supply.m` (65 satır, ölçülmüş çıktılı) |
| `src/bilimsel_hesap_makinesi_gui.m` | `function` sarmalı eski GUI sürümü (118 satır) | `bilimsel_hesap_makinesi_gui.m` (betik, koşuyor) |

## 2. `kok-20261021/` — kök kirliliği (3 dosya)

| Dosya | Ne | Neden kökten çıktı |
|---|---|---|
| `venn_script.m` | 2025'ten kalma, `print -dpng /Users/hakankilicaslan/...` **mutlak yol** yazan 28 satırlık deneme | Kökte tek başına `octave-cli` ile koşmuyordu; işlevi `venn_diagrami.m`'de |
| `yeni.txt` | 3,6 KB'lik çiğ soru/not metni (markdown taslağı) | Yayınlanacak belge değil; `.gitignore`'da zaten vardı, kökte duruyordu |
| `octave-workspace` | Octave'ın `save` ile bıraktığı **ikili** çalışma alanı (venn demosunun değişkenleri) | İkili dosya; Jekyll'ın kökünde yeri yok |

> `assets/img/venn_diagram.png` (eski betiğin çıktısı) **silinmedi**: yayınlanmış bir varlık, dış bağ hedefi olabilir.
> Yeni not `assets/img/venn_diagrami.png` üretir; ikisi farklı dosyadır.
