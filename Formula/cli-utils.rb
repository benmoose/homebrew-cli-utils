class CliUtils < Formula
  desc "Collection of useful Zsh CLI functions"
  homepage "https://github.com/benmoose/homebrew-cli-utils"
  url "https://github.com/benmoose/homebrew-cli-utils/archive/refs/tags/v0.0.50.tar.gz"
  sha256 "f390d1f2846bac4c7fcd64cd175fcf7d614c9e1f0ae83de9b4d4751d4758ce37"
  license "GPL-3.0"
  head "https://github.com/benmoose/homebrew-cli-utils.git", branch: "main"

  def install
    prefix.install_metafiles

    pkgshare.install Dir["src/private/*"]
    pkgshare.install Dir["src/public/*"]

    inreplace "src/init.sh", "<<FN_DIR>>", opt_pkgshare
    bin.install "src/init.sh" => "init-#{name}"
  end

  def post_install
    system "source", "init-#{name}", "-l"
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
