class CliUtils < Formula
  desc "Collection of useful Zsh CLI functions"
  homepage "https://github.com/benmoose/homebrew-cli-utils"
  url "https://github.com/benmoose/homebrew-cli-utils/archive/refs/tags/v0.0.60.tar.gz"
  sha256 "3b05c3e164f848430def70ece9026240bb03addfb5c6ccca72f794c7c3b4bcd8"
  license "GPL-3.0-or-later"
  head "https://github.com/benmoose/homebrew-cli-utils.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+){2})$/i)
  end

  def install
    prefix.install_metafiles
    pkgshare.install Dir["src/private/*"]
    pkgshare.install Dir["src/public/*"]
    
    inreplace "src/init.sh", "__OPT_PKGSHARE__", opt_pkgshare
    bin.install "src/init.sh" => name
  end

  def caveats
    <<~EOS
      cli-utils installed! To make Add this to your .zshrc:

        source $(which cli-utils)

    EOS
  end

  test do

    assert_match("builtin autoload", shell_output("zsh -c 'source #{opt_pkgshare} uuid && $functions[uuid]'"))

    uuid_out = shell_output("zsh -c 'uuid'").rstrip
    assert_match(/^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$/, uuid_out)
  end
end
