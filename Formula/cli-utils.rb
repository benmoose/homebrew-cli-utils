class CliUtils < Formula
  desc "Collection of useful Zsh CLI functions"
  homepage "https://github.com/benmoose/homebrew-cli-utils"
  url "https://github.com/benmoose/homebrew-cli-utils/archive/refs/tags/v0.0.41.tar.gz"
  sha256 "6eadf8f37700b84b4be143488e845938485a6fc98ce88428f52cf45b1f4df748"
  license "GPL-3.0-or-later"
  head "https://github.com/benmoose/homebrew-cli-utils.git", branch: "main"

  def install
    prefix.install_metafiles

    (pkgshare/"functions").install Dir["src/private/*"]
    (pkgshare/"functions").install Dir["src/public/*"]
    pkgshare.install "src/init.sh"
  end

  def caveats
    <<~EOS
      cli-utils installed! To make Add this to your .zshrc:

        source "$(brew --prefix #{name})#{opt_pkgshare.to_s.delete_prefix(opt_prefix)}/init.sh"
    
    EOS
  end

  # test do
  #   assert_match("builtin autoload", shell_output("zsh -c 'source #{opt_pkgshare} uuid && $functions[uuid]'"))

  #   uuid_out = shell_output("zsh -c 'uuid'").rstrip
  #   assert_match(/^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$/, uuid_out)
  # end
end
