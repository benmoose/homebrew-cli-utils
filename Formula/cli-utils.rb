class CliUtils < Formula
  desc "Collection of useful Zsh CLI functions"
  homepage "https://github.com/benmoose/homebrew-cli-utils"
  url "https://github.com/benmoose/homebrew-cli-utils/archive/refs/tags/v0.0.35.tar.gz"
  sha256 "153f9213eaf3eca8cf5c5585bafb655f8494dca07a4e2bef7b56c25b7af7eeb0"
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
      Add this to your .zshrc:

        source "$(brew --prefix)#{opt_pkgshare.to_s.delete_prefix(HOMEBREW_PREFIX)}/init.sh"
    EOS
  end

  # test do
  #   assert_match("builtin autoload", shell_output("zsh -c 'source #{opt_pkgshare} uuid && $functions[uuid]'"))

  #   uuid_out = shell_output("zsh -c 'uuid'").rstrip
  #   assert_match(/^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$/, uuid_out)
  # end
end
