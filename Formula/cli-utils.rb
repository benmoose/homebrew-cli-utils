class CliUtils < Formula
  desc "Collection of useful Zsh CLI functions"
  homepage "https://github.com/benmoose/homebrew-cli-utils"
  url "https://github.com/benmoose/homebrew-cli-utils/archive/refs/tags/v0.0.18.tar.gz"
  sha256 "d80b83b2e5e520c531094b4b8a49814c09c2f13db85af4dc2294d9dc4173910c"
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
