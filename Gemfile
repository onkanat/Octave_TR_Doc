source "https://rubygems.org"

# W8 — VAKIF kabuğu için yerel build pini.
# GitHub Pages derlemesi (actions/jekyll-build-pages) kendi konteynerindeki
# github-pages paketini kullanır; bu Gemfile yalnız YEREL doğrulama içindir
# (bkz. SARTNAME-W8 §2.6). Sürümler GitHub Pages 231 ile aynı hatta çivilidir.
gem "jekyll", "3.9.5"

group :jekyll_plugins do
  gem "jekyll-redirect-from", "0.16.0"
  gem "jekyll-optional-front-matter", "0.3.2"
  gem "jekyll-titles-from-headings", "0.5.3"
  gem "jekyll-relative-links", "0.6.1"
  gem "jekyll-sitemap", "1.4.0"
end

gem "kramdown-parser-gfm", "1.1.0"
gem "rouge", "3.30.0"

# Ruby 2.6 (sistem) uyumu: ffi >= 1.17 Ruby >= 3.0 ister.
gem "ffi", "1.16.3"
