class CliUtils < Formula
  desc "Collection of useful Zsh CLI functions"
  homepage "https://github.com/benmoose/homebrew-cli-utils"
  url "https://github.com/benmoose/homebrew-cli-utils/archive/refs/tags/v0.0.51.tar.gz"
  sha256 "88878e5ad21c0a2e2e9473d686837c8146df2a684db31db03699fda3c5713581"
  license "GPL-3.0"
  head "https://github.com/benmoose/homebrew-cli-utils.git", branch: "main"

  def install
    prefix.install_metafiles

    pkgshare.install Dir["src/private/*"]
    pkgshare.install Dir["src/public/*"]

    inreplace "src/init.sh", "<<FN_DIR>>", opt_pkgshare
    bin.install "src/init.sh" => "init-#{name}"
  end

  def caveats
    <<~EOS
      cli-utils installed! To make Add this to your .zshrc:

        source $(init-cli-utils -l)
    
    EOS
  end

  # test do
  #   assert_match("builtin autoload", shell_output("zsh -c 'source #{opt_pkgshare} uuid && $functions[uuid]'"))

  #   uuid_out = shell_output("zsh -c 'uuid'").rstrip
  #   assert_match(/^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$/, uuid_out)
  # end
end
