class CliUtils < Formula
  desc "Collection of useful Zsh CLI functions"
  homepage "https://github.com/benmoose/homebrew-cli-utils"
  url "https://github.com/benmoose/homebrew-cli-utils/archive/refs/tags/v0.0.47.tar.gz"
  sha256 "0199a291a35a52d65571cf24bf865a1ddce46dff7767d8d2d3ac67c013b639c7"
  license "GPL-3.0"
  head "https://github.com/benmoose/homebrew-cli-utils.git", branch: "main"

  def install
    prefix.install_metafiles

    pkgshare.install Dir["src/private/*"]
    pkgshare.install Dir["src/public/*"]

    # bin.install "src/init.sh" => "init-cli-utils"
    (bin/"init-cli-utils").write_env_script "src/init.sh", CLI_UTILS_FN_DIR: opt_pkgshare
  end

  def caveats
    <<~EOS
      cli-utils installed! To make Add this to your .zshrc:

        source init-cli-utils
        source "$(brew --prefix #{name})#{opt_pkgshare.to_s.delete_prefix(opt_prefix)}/init.sh"
    
    EOS
  end

  # test do
  #   assert_match("builtin autoload", shell_output("zsh -c 'source #{opt_pkgshare} uuid && $functions[uuid]'"))

  #   uuid_out = shell_output("zsh -c 'uuid'").rstrip
  #   assert_match(/^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$/, uuid_out)
  # end
end
