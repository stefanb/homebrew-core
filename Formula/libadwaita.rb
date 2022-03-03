class Libadwaita < Formula
  desc "Building blocks for modern adaptive GNOME applications"
  homepage "https://gnome.pages.gitlab.gnome.org/libadwaita/"
  url "https://download.gnome.org/sources/libadwaita/1.0/libadwaita-1.0.2.tar.xz"
  sha256 "79e56011f5532fba6cb02531249d2bcfb8a6c42495c7a7de92f8819661fea091"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 arm64_monterey: "c88a962ad53cc5965136aa38ebdd058f1fe2c34e5e21d3490b81435bc4d508d9"
    sha256 arm64_big_sur:  "cc52f34b8328adc4266e5391dd11d335eae0413f05867266455b19d7bcb90451"
    sha256 monterey:       "d5a6991723d6f25f547313b98f35de3d8ac6cd4f2907b6f35cae7a25c1cbcb7d"
    sha256 big_sur:        "1f248de299d342c65b8f928801d42382f130786ac05bfa451bb70c1fe6b8676d"
    sha256 catalina:       "ef6eacabf8994d4b48a4769069782c3bc8dfd02fbcf2fee9ad43f1db5465812a"
    sha256 x86_64_linux:   "252d8427bfa691cb4ece1ff6f1d5a9812b955f74d4f99c3d514280df6afc0db7"
  end

  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "sassc" => :build
  depends_on "vala" => :build
  depends_on "gtk4"

  def install
    args = std_meson_args + %w[
      -Dtests=false
    ]

    mkdir "build" do
      system "meson", *args, ".."
      system "ninja", "-v"
      system "ninja", "install", "-v"
    end
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <adwaita.h>

      int main(int argc, char *argv[]) {
        g_autoptr (AdwApplication) app = NULL;
        app = adw_application_new ("org.example.Hello", G_APPLICATION_FLAGS_NONE);
        return g_application_run (G_APPLICATION (app), argc, argv);
      }
    EOS
    flags = shell_output("#{Formula["pkg-config"].opt_bin}/pkg-config --cflags --libs libadwaita-1").strip.split
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test", "--help"

    # include a version check for the pkg-config files
    assert_match version.to_s, (lib/"pkgconfig/libadwaita-1.pc").read
  end
end
