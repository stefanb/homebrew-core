class Frps < Formula
  desc "Server app of fast reverse proxy to expose a local server to the internet"
  homepage "https://github.com/fatedier/frp"
  url "https://github.com/fatedier/frp.git",
      tag:      "v0.39.1",
      revision: "88fcc079e881108c868e64831c97b30a855e5d26"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3015ad5296d536227e46b27d8b0f8dbb67940682965c6bdd4aeb37f11256328d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3015ad5296d536227e46b27d8b0f8dbb67940682965c6bdd4aeb37f11256328d"
    sha256 cellar: :any_skip_relocation, monterey:       "aedc135e88f5ef2063fc3c267a147c7a6bf9754a5e6ffe6dff7d6d5a2de47bd7"
    sha256 cellar: :any_skip_relocation, big_sur:        "aedc135e88f5ef2063fc3c267a147c7a6bf9754a5e6ffe6dff7d6d5a2de47bd7"
    sha256 cellar: :any_skip_relocation, catalina:       "aedc135e88f5ef2063fc3c267a147c7a6bf9754a5e6ffe6dff7d6d5a2de47bd7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b7c0bfba22870868f4c3ea533544f6bee7513a0bf173fa5720b43d75f54faf9f"
  end

  depends_on "go" => :build

  def install
    (buildpath/"bin").mkpath
    (etc/"frp").mkpath

    system "make", "frps"
    bin.install "bin/frps"
    etc.install "conf/frps.ini" => "frp/frps.ini"
    etc.install "conf/frps_full.ini" => "frp/frps_full.ini"
  end

  service do
    run [opt_bin/"frps", "-c", etc/"frp/frps.ini"]
    keep_alive true
    error_log_path var/"log/frps.log"
    log_path var/"log/frps.log"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/frps -v")
    assert_match "Flags", shell_output("#{bin}/frps --help")

    read, write = IO.pipe
    fork do
      exec bin/"frps", out: write
    end
    sleep 3

    output = read.gets
    assert_match "frps uses command line arguments for config", output
  end
end
