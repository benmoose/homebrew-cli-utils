class CliUtils < Formula
  desc "Collection of useful Zsh CLI functions"
  homepage "https://github.com/benmoose/homebrew-cli-utils"
  url "https://github.com/benmoose/homebrew-cli-utils/archive/refs/tags/v0.0.94.tar.gz"
  sha256 "0b528b69e9f00fe36d071477e9e65a6e00af4e23686c6d4f4cb03cbaf6515e09"
  license "GPL-3.0-or-later"
  head "https://github.com/benmoose/homebrew-cli-utils.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+){2})$/i)
  end

  def install
    prefix.install_metafiles
    zsh_function.install Dir["src/private/*"]
    zsh_function.install Dir["src/public/*"]

    pkgshare.install "src/spinners.txt"
    pkgshare.install "src/init-env.zsh"
    pkgshare.install "src/init.zsh"
    prefix.install_symlink pkgshare/"init.zsh" => "init"

    libexec.install "src/install.zsh"
    bin.install_symlink libexec/"install.zsh" => installer_name
  end

  def caveats
    <<~EOS
      To autoload functions, add this to your profile:
        source #{opt_prefix}/init

      or run `#{installer_name}` to configure .zshrc automatically.
    EOS
  end

  test do
    expect(formula.pkgshare).to be_a_directory
  end

  private

  def installer_name
    "install-#{name}"
  end
end
