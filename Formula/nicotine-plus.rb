class NicotinePlus < Formula
  include Language::Python::Virtualenv

  desc "Graphical client for the Soulseek file sharing network"
  homepage "https://nicotine-plus.github.io/nicotine-plus/"
  url "https://files.pythonhosted.org/packages/25/76/9ef26b9311b8a475d15a4173789a463fa9dc28cff0d11e9d3edd34da3889/nicotine-plus-3.2.0.tar.gz"
  sha256 "aca21de8596a81a54fdd306b5e1338fd530e94c983e01425dcaf48e6e1395785"
  license "GPL-3.0-or-later"
  head "https://github.com/Nicotine-Plus/nicotine-plus.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b238a3872d2d05e9abf72ed166c77d5e9dc74c6ef4a9b9108ed63282e9a3fb6d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a7fa6eec8feed00ddc8740ca997a1e10ec7589e9db24f5cf1736e55994bf6b87"
    sha256 cellar: :any_skip_relocation, monterey:       "e747f405686ef55476b094601d70d00af6793219fa9805871bb977770760621b"
    sha256 cellar: :any_skip_relocation, big_sur:        "e747f405686ef55476b094601d70d00af6793219fa9805871bb977770760621b"
    sha256 cellar: :any_skip_relocation, catalina:       "e747f405686ef55476b094601d70d00af6793219fa9805871bb977770760621b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ddee5cdc6d4015953c6097cfb273aef30ccb3cf1e8502cb59db6a799c53b3d7a"
  end

  depends_on "adwaita-icon-theme"
  depends_on "gtk+3"
  depends_on "py3cairo"
  depends_on "pygobject3"
  depends_on "python@3.9"

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/nicotine -v")
    pid = fork do
      exec bin/"nicotine", "-s"
    end
    sleep 3
    Process.kill("TERM", pid)
  end
end
