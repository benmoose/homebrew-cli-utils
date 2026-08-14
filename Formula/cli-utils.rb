class CliUtils < Formula
  desc "Collection of useful Zsh CLI functions"
  homepage "https://github.com/benmoose/homebrew-cli-utils"
  url "https://github.com/benmoose/homebrew-cli-utils/archive/refs/tags/v0.0.46.tar.gz"
  sha256 "7d5abf2dae486766d220a237c4a1fabc8e0cad5eaa1b5e920710a1cd00ab0a3e"
  license "GPL-3.0"
  head "https://github.com/benmoose/homebrew-cli-utils.git", branch: "main"

  def install
    prefix.install_metafiles

    (pkgshare/"functions").install Dir["src/private/*"]
    (pkgshare/"functions").install Dir["src/public/*"]

    bin.install "src/init.sh" => "init-cli-utils"
    (bin/"init-cli-utils").write_env_script "src/init.sh" CLI_UTILS_FN_DIR: opt_pkgshare/"functions"
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
