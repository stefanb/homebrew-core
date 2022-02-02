class Karchive < Formula
  desc "Reading, creating, and manipulating file archives"
  homepage "https://api.kde.org/frameworks/karchive/html/index.html"
  url "https://download.kde.org/stable/frameworks/5.90/karchive-5.90.0.tar.xz"
  sha256 "a6e2f3a7cb1aef7db7b4f7dfb9ffb1d929d0d5b147c25a93fbc0b794dfcd2110"
  license all_of: [
    "BSD-2-Clause",
    "LGPL-2.0-only",
    "LGPL-2.0-or-later",
    any_of: ["LGPL-2.0-only", "LGPL-3.0-only"],
  ]
  head "https://invent.kde.org/frameworks/karchive.git", branch: "master"

  # We check the tags from the `head` repository because the latest stable
  # version doesn't seem to be easily available elsewhere.
  livecheck do
    url :head
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "3d21a41d10ce140c3374635294ae57f7e51f0b65668320ac06d9ed4b80f39b0f"
    sha256 cellar: :any,                 arm64_big_sur:  "e218ad60f4488d3c981787aa5c96d01dc87fabfaadcc555adbf9f553a1fe9e12"
    sha256 cellar: :any,                 big_sur:        "1476bec15931fa363e662d4a354587429628c09b584e8d7b8c1a20946d28a477"
    sha256 cellar: :any,                 catalina:       "ea356880c2b7e798654185a759be98f9f25c88b8d853fb9c283ba6f537cd60d1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0dd9cf8e74005e96ab12c5c5e8b9133dc3908150f5ee857fe17bdb7451580ddf"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "doxygen" => :build
  depends_on "extra-cmake-modules" => [:build, :test]
  depends_on "graphviz" => :build

  depends_on "qt@5"
  depends_on "xz"
  depends_on "zstd"

  uses_from_macos "bzip2"
  uses_from_macos "zlib"

  on_linux do
    depends_on "gcc"
  end

  fails_with gcc: "5"

  def install
    args = std_cmake_args + %w[
      -S .
      -B build
      -DBUILD_QCH=ON
    ]

    system "cmake", *args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    pkgshare.install "examples"
  end

  test do
    ENV.delete "CPATH"
    args = std_cmake_args + %W[
      -DQt5Core_DIR=#{Formula["qt@5"].opt_lib}/cmake/Qt5Core
      -DQT_MAJOR_VERSION=5
    ]

    %w[bzip2gzip
       helloworld
       tarlocalfiles
       unzipper].each do |test_name|
      mkdir test_name.to_s do
        system "cmake", (pkgshare/"examples/#{test_name}"), *args
        system "make"
      end
    end
  end
end
