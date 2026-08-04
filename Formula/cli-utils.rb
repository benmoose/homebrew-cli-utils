class CliUtils < Formula
  desc "Collection of useful Zsh CLI functions"
  homepage "https://github.com/benmoose/homebrew-cli-utils"
  url "https://github.com/benmoose/homebrew-cli-utils/archive/refs/tags/v0.0.25.tar.gz"
  sha256 "9a53c1bb0df4520e4af6debf385929ad49b7d07e10c45b796ac592885bf4aaa8"
  license "GPL-3.0-or-later"
  head "https://github.com/benmoose/homebrew-cli-utils.git", branch: "main"

  def install
    prefix.install_metafiles

    (pkgshare/"functions").install Dir["functions/private/*"]
    (pkgshare/"functions").install Dir["functions/public/*"]
    pkgshare.install "functions/init.sh"
  end

  def caveats
    <<~EOS
      Add this to your .zshrc:

        source "#{opt_pkgshare}/init.sh"
    EOS
  end

  # test do
  #   assert_match("builtin autoload", shell_output("zsh -c 'source #{opt_pkgshare} uuid && $functions[uuid]'"))

  #   uuid_out = shell_output("zsh -c 'uuid'").rstrip
  #   assert_match(/^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$/, uuid_out)
  # end
end
