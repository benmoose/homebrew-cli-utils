class CliUtils < Formula
  desc "Collection of useful Zsh CLI functions"
  homepage "https://github.com/benmoose/homebrew-cli-utils"
  url "https://github.com/benmoose/homebrew-cli-utils/archive/refs/tags/v0.0.17.tar.gz"
  sha256 "648d96ec315af41b71b57399c8cdfd7fa8576b34cbc2acd25a19560881e86e32"
  license "GPL-3.0-or-later"
  head "https://github.com/benmoose/homebrew-cli-utils.git", branch: "main"

  def install
    prefix.install_metafiles

    libexec.install Dir["functions/private/_*"]
    libexec.install Dir["functions/public/*"]
    libexec.install "functions/init.sh"
    
    bin.write_exec_script (libexec/"init.sh"), [libexec]
  end

  def caveats
    <<~EOS
      Add this to your .zshrc:

        ./init-cli-utils.sh #{opt_pkgshare}
    EOS
  end

  # test do
  #   assert_match("builtin autoload", shell_output("zsh -c 'source #{opt_pkgshare} uuid && $functions[uuid]'"))

  #   uuid_out = shell_output("zsh -c 'uuid'").rstrip
  #   assert_match(/^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$/, uuid_out)
  # end
end
