class Asymptote < Formula
  desc "Powerful descriptive vector graphics language"
  homepage "https://asymptote.sourceforge.io"
  # Keep version in sync with manual below
  url "https://downloads.sourceforge.net/project/asymptote/2.77/asymptote-2.77.src.tgz"
  sha256 "ae3ddc8e37ae666c75cbd23cd8b42df9c5e95ef6c311b5a2ee4db8b3c643b96c"
  license "LGPL-3.0-only"
  revision 1

  livecheck do
    url :stable
    regex(%r{url=.*?/asymptote[._-]v?(\d+(?:\.\d+)+)\.src\.t}i)
  end

  bottle do
    sha256 arm64_monterey: "1fa6523b4285ee7000365f625883edcc4f24ad98446bada442332379abed7177"
    sha256 arm64_big_sur:  "d597787d34ddcf37435190d335ac2d5aec7f6789ad1b7ec49a84406640f92f47"
    sha256 monterey:       "3f691854914dc8ab1a13d2886879a149e530af8de55d87d61037dce4fb587944"
    sha256 big_sur:        "320a493a9321b9321f2cb4a2eec3d092dbd4a743d36fbe3582a1563d904e0045"
    sha256 catalina:       "5634fad0e28688bc688f2ddac14ee4101155966baa826616789d30fc87c22b00"
    sha256 x86_64_linux:   "6e63c22cae23ea6692b171f6c0422201d66649eee4be3fb8537608316f1977aa"
  end

  depends_on "glm" => :build
  depends_on "fftw"
  depends_on "ghostscript"
  depends_on "gsl"
  depends_on "readline"

  uses_from_macos "ncurses"

  on_linux do
    depends_on "freeglut"
  end

  resource "manual" do
    url "https://downloads.sourceforge.net/project/asymptote/2.77/asymptote.pdf"
    sha256 "21e23e4721434e9168a88185a58d84e565da7ea09748d85d2c19786ba229542b"
  end

  def install
    system "./configure", *std_configure_args

    # Avoid use of MacTeX with these commands
    # (instead of `make all && make install`)
    touch buildpath/"doc/asy-latex.pdf"
    system "make", "asy"
    system "make", "asy-keywords.el"
    system "make", "install-asy"

    doc.install resource("manual")
    (share/"emacs/site-lisp").install_symlink pkgshare
  end

  test do
    (testpath/"line.asy").write <<~EOF
      settings.outformat = "pdf";
      size(200,0);
      draw((0,0)--(100,50),N,red);
    EOF
    system "#{bin}/asy", testpath/"line.asy"
    assert_predicate testpath/"line.pdf", :exist?
  end
end
