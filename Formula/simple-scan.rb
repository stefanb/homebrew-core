class SimpleScan < Formula
  desc "GNOME document scanning application"
  homepage "https://gitlab.gnome.org/GNOME/simple-scan"
  url "https://download.gnome.org/sources/simple-scan/40/simple-scan-40.7.tar.xz"
  sha256 "7c551852cb5af7d34aa989f8ad5ede3cbe31828cf8dd5aec2b2b6fdcd1ac3d53"
  license "GPL-3.0-or-later"

  bottle do
    sha256 arm64_monterey: "c7ef8af7d4e5d34567642084386302374abfb8ef05934046f4f2a0d66effa736"
    sha256 arm64_big_sur:  "4bae5ca76e7dcf4ce042001134926e693df7130cfc818c86f6e2d60b1b3cdd13"
    sha256 monterey:       "292f3703162d805bdaa178c94810a2d32092310520f4d5fdaac24a430cc3e85f"
    sha256 big_sur:        "e0c98f814d427e8841231d9c497def9b7e3a8a8f0dc9adb7842e27e9dc560c29"
    sha256 catalina:       "2e71257a943ada0dfe2e4fec0ed8ac14c996e64a817ce6f952e7a1968335f06b"
    sha256 x86_64_linux:   "1c4641ee787593202ce678cc0f3d27a105c0647d5921db31cb83ad7c5d177758"
  end

  depends_on "itstool" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "vala" => :build
  depends_on "glib"
  depends_on "gtk+3"
  depends_on "libgusb"
  depends_on "libhandy"
  depends_on "sane-backends"
  depends_on "webp"

  # Fix build with Meson 0.60+. Remove when the following commit is in a tagged release:
  # https://gitlab.gnome.org/GNOME/simple-scan/-/commit/da6626debe00be1a0660f30cf2bf7629186c01d5
  patch do
    url "https://gitlab.gnome.org/GNOME/simple-scan/-/commit/da6626debe00be1a0660f30cf2bf7629186c01d5.diff"
    sha256 "3a96ea449fe1a7b8bee34efdf21ca48f893f0cadb3ba3d4cb742afea3b8c4c03"
  end

  def install
    ENV["DESTDIR"] = "/"
    mkdir "build" do
      system "meson", *std_meson_args, ".."
      system "ninja", "-v"
      system "ninja", "install", "-v"
    end
  end

  def post_install
    system "#{Formula["glib"].opt_bin}/glib-compile-schemas", "#{HOMEBREW_PREFIX}/share/glib-2.0/schemas"
    system "#{Formula["gtk+3"].opt_bin}/gtk3-update-icon-cache", "-f", "-t", "#{HOMEBREW_PREFIX}/share/icons/hicolor"
  end

  test do
    # Errors with `Cannot open display`
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"].present?

    system "#{bin}/simple-scan", "-v"
  end
end
