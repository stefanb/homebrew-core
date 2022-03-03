class Ortp < Formula
  desc "Real-time transport protocol (RTP, RFC3550) library"
  homepage "https://www.linphone.org/technical-corner/ortp"
  url "https://gitlab.linphone.org/BC/public/ortp/-/archive/5.1.3/ortp-5.1.3.tar.bz2"
  sha256 "80f1c5c33900c9dddb60248ce5b8f07af2d75275af340a42616a73dff2762fa4"
  license "GPL-3.0-or-later"
  head "https://gitlab.linphone.org/BC/public/ortp.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "fc903ecf8b59424388d2a5d09d54c4c4808041945dd1aca27a24ca1d61ae1deb"
    sha256 cellar: :any,                 arm64_big_sur:  "b6713abf4879ad5c4f7a5cb8ea1ebdf8f49aad80cf7d89517e08a75b982263e5"
    sha256 cellar: :any,                 monterey:       "c91238ca897a44b9b7a42e729c30ecebfdff202562cf678812176604d09d6b80"
    sha256 cellar: :any,                 big_sur:        "019e933d5a8d4f001a8474270576cb30dad73c224eb4d2b49eaae7f1ce95c1c0"
    sha256 cellar: :any,                 catalina:       "fb93f422a152fd3c20cef2da373a3719b0776d9582dd3b6be7f273ba9871776b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3f838381e1fe9f93fbcf3c8845d15640b58869607583d0ad41ee4ec0f44dcf67"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "mbedtls@2"

  # bctoolbox appears to follow ortp's version. This can be verified at the GitHub mirror:
  # https://github.com/BelledonneCommunications/bctoolbox
  resource "bctoolbox" do
    url "https://gitlab.linphone.org/BC/public/bctoolbox/-/archive/5.1.3/bctoolbox-5.1.3.tar.bz2"
    sha256 "272fe3b419c7ce8c9b042f2cdcd800a8b04940e5fedd1d488112c9bd471ee961"
  end

  def install
    resource("bctoolbox").stage do
      system "cmake", ".", *std_cmake_args(install_prefix: libexec), "-DENABLE_TESTS_COMPONENT=OFF"
      system "make", "install"
    end

    ENV.prepend_path "PKG_CONFIG_PATH", libexec/"lib/pkgconfig"
    ENV.append "LDFLAGS", "-Wl,-rpath,#{libexec}/lib" if OS.linux?

    args = std_cmake_args + %W[
      -DCMAKE_PREFIX_PATH=#{libexec}
      -DCMAKE_C_FLAGS=-I#{libexec}/include
      -DCMAKE_CXX_FLAGS=-I#{libexec}/include
      -DENABLE_DOC=NO
    ]
    mkdir "build" do
      system "cmake", "..", *args
      system "make", "install"
    end
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include "ortp/logging.h"
      #include "ortp/rtpsession.h"
      #include "ortp/sessionset.h"
      int main()
      {
        ORTP_PUBLIC void ortp_init(void);
        return 0;
      }
    EOS
    system ENV.cc, "-I#{include}", "-I#{libexec}/include", "-L#{lib}", "-lortp",
           testpath/"test.c", "-o", "test"
    system "./test"

    # Ensure that bctoolbox's version is identical to ortp's.
    assert_equal version, resource("bctoolbox").version
  end
end
