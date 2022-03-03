class Inxi < Formula
  desc "Full featured CLI system information tool"
  homepage "https://smxi.org/docs/inxi.htm"
  url "https://github.com/smxi/inxi/archive/3.3.13-1.tar.gz"
  sha256 "44d11d88fc0fd2213401436d8e7d09b755ab8af3ca10443d7f4fb32edae92fef"
  license "GPL-3.0-or-later"
  head "https://github.com/smxi/inxi.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "85d6627720fcdae437cff245c2e778b50b4ef45f50a3c78b80c0681696cda094"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "85d6627720fcdae437cff245c2e778b50b4ef45f50a3c78b80c0681696cda094"
    sha256 cellar: :any_skip_relocation, monterey:       "ef47928c9f2cef54251859d947a0378cfad528f8fb01da4f31140ad3733fd848"
    sha256 cellar: :any_skip_relocation, big_sur:        "ef47928c9f2cef54251859d947a0378cfad528f8fb01da4f31140ad3733fd848"
    sha256 cellar: :any_skip_relocation, catalina:       "ef47928c9f2cef54251859d947a0378cfad528f8fb01da4f31140ad3733fd848"
  end

  def install
    bin.install "inxi"
    man1.install "inxi.1"

    ["LICENSE.txt", "README.txt", "inxi.changelog"].each do |file|
      prefix.install file
    end
  end

  test do
    inxi_output = shell_output("#{bin}/inxi")

    uname = shell_output("uname").strip
    assert_match uname.to_str, inxi_output.to_s

    uname_r = shell_output("uname -r").strip
    assert_match uname_r.to_str, inxi_output.to_s
  end
end
