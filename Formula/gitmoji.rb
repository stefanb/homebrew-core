require "language/node"

class Gitmoji < Formula
  desc "Interactive command-line tool for using emoji in commit messages"
  homepage "https://gitmoji.dev"
  url "https://registry.npmjs.org/gitmoji-cli/-/gitmoji-cli-4.8.0.tgz"
  sha256 "3fe3f0df9cab64c1775b507bc01556bd351173caffe0961f4ef3194c7630da09"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3fd85862428ed980e564d51104c67a17a269fbf61ac2aca4b314089a67c49d58"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3fd85862428ed980e564d51104c67a17a269fbf61ac2aca4b314089a67c49d58"
    sha256 cellar: :any_skip_relocation, monterey:       "e78eda629e0f3cccf78be72d4a8a55a31b87bf198b89e51b82e974f563fd43c9"
    sha256 cellar: :any_skip_relocation, big_sur:        "e78eda629e0f3cccf78be72d4a8a55a31b87bf198b89e51b82e974f563fd43c9"
    sha256 cellar: :any_skip_relocation, catalina:       "e78eda629e0f3cccf78be72d4a8a55a31b87bf198b89e51b82e974f563fd43c9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3fd85862428ed980e564d51104c67a17a269fbf61ac2aca4b314089a67c49d58"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match ":bug:", shell_output("#{bin}/gitmoji --search bug")
  end
end
