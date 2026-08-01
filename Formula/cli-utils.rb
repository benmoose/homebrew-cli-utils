class CliUtils < Formula
  desc "Collection of useful Zsh CLI functions"
  homepage "https://github.com/benmoose/homebrew-cli-utils"
  url "https://github.com/benmoose/homebrew-cli-utils/archive/refs/tags/v0.0.19.tar.gz"
  sha256 "bc2068e305e887f4822e480e9dad01f1aefcd0b15c853fccb2adce33fd1dabe5"
  license "GPL-3.0-or-later"
  head "https://github.com/benmoose/homebrew-cli-utils.git", branch: "main"

  def install
    prefix.install_metafiles

    pkgshare.install Dir["functions/private/*"]
    pkgshare.install Dir["functions/public/*"]
    pkgshare.install Dir["functions/init.sh"]
    
    bin.write_exec_script Dir[pkgshare/"init.sh"], [pkgshare]
  end

  def caveats
    <<~EOS
      Add this to your .zshrc:

        init.sh
    EOS
  end

  # test do
  #   assert_match("builtin autoload", shell_output("zsh -c 'source #{opt_pkgshare} uuid && $functions[uuid]'"))

  #   uuid_out = shell_output("zsh -c 'uuid'").rstrip
  #   assert_match(/^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$/, uuid_out)
  # end
end
