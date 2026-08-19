class CliUtils < Formula
  desc "Collection of useful Zsh CLI functions"
  homepage "https://github.com/benmoose/homebrew-cli-utils"
  url "https://github.com/benmoose/homebrew-cli-utils/archive/refs/tags/v0.0.56.tar.gz"
  sha256 "193ab8de3d3b2a812c0d5d3a1e293b6257e37a5d0ce2ef424aa172e2679d764a"
  license "GPL-3.0"
  head "https://github.com/benmoose/homebrew-cli-utils.git", branch: "main"

  def install
    prefix.install_metafiles

    pkgshare.install Dir["src/private/*"]
    pkgshare.install Dir["src/public/*"]

    inreplace "src/init.sh", "<<FN_DIR>>", opt_pkgshare
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
