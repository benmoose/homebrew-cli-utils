class CliUtils < Formula
  desc "Collection of useful Zsh CLI functions"
  homepage "https://github.com/benmoose/homebrew-cli-utils"
  url "https://github.com/benmoose/homebrew-cli-utils/archive/refs/tags/v0.0.53.tar.gz"
  sha256 "d0439108f35d09e7420fa3f593cd688750658cdbc8149ee4c7e001dde6b24571"
  license "GPL-3.0"
  head "https://github.com/benmoose/homebrew-cli-utils.git", branch: "main"

  def install
    prefix.install_metafiles

    pkgshare.install Dir["src/private/*"]
    pkgshare.install Dir["src/public/*"]

    inreplace "src/init.sh", ".(fn-dir)", opt_pkgshare
    bin.install "src/init.sh" => name
  end

  def caveats
    <<~EOS
      cli-utils installed! To make Add this to your .zshrc:

        source $(cli-utils --init)
    
    EOS
  end

  # test do
  #   assert_match("builtin autoload", shell_output("zsh -c 'source #{opt_pkgshare} uuid && $functions[uuid]'"))

  #   uuid_out = shell_output("zsh -c 'uuid'").rstrip
  #   assert_match(/^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$/, uuid_out)
  # end
end
