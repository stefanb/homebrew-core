class Pdftoipe < Formula
  desc "Reads arbitrary PDF files and generates an XML file readable by Ipe"
  homepage "https://github.com/otfried/ipe-tools"
  url "https://github.com/otfried/ipe-tools/archive/v7.2.24.1.tar.gz"
  sha256 "561b18fc2a7ae45c37c5d0390443b37f4585549f09cd7765d856456be24e5dbc"
  license "GPL-2.0-or-later"
  revision 4

  bottle do
    sha256 cellar: :any, arm64_monterey: "3ab6a38078e56d64e493b40ffca5eed6cd1bae0286ee487c5b4b429e9d44f850"
    sha256 cellar: :any, arm64_big_sur:  "60ef16eb2b4a7d2c128b045d753a72c62de79dee856629479f76ed0b20f96c1b"
    sha256 cellar: :any, monterey:       "0786e636f7046f93bdb3a04948ce1e18addc65e330b0ff966ebbec5b4fbf084e"
    sha256 cellar: :any, big_sur:        "6756d901b8e14244157ac0c4f139ef530c9f5159cf31603ad3ab639d65e62fc3"
    sha256 cellar: :any, catalina:       "08b6e6e6bfd3479c3941d016916d3eb649cf007c16a34f81e3562f540a9085a3"
  end

  depends_on "pkg-config" => :build
  depends_on "poppler"

  def install
    cd "pdftoipe" do
      system "make"
      bin.install "pdftoipe"
      man1.install "pdftoipe.1"
    end
  end

  test do
    cp test_fixtures("test.pdf"), testpath
    system bin/"pdftoipe", "test.pdf"
    assert_match "<ipestyle>", File.read("test.ipe")
  end
end
