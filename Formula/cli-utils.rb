class CliUtils < Formula
  desc "Collection of useful Zsh CLI functions"
  homepage "https://github.com/benmoose/homebrew-cli-utils"
  url "https://github.com/benmoose/homebrew-cli-utils/archive/refs/tags/v0.0.21.tar.gz"
  sha256 "eddb8453bf2f45a017e8286c0f120f70c5a912358ecd58ef8643cb7f9d9724e4"
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
