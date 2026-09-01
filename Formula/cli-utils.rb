class CliUtils < Formula
  desc "Collection of useful Zsh CLI functions"
  homepage "https://github.com/benmoose/homebrew-cli-utils"
  url "https://github.com/benmoose/homebrew-cli-utils/archive/refs/tags/v0.0.100.tar.gz"
  sha256 "577b0aa3d02f0d825b2decd0b69af6bb3d98f1274748d025ecb0dcfa2e7088ac"
  license "GPL-3.0-or-later"
  head "https://github.com/benmoose/homebrew-cli-utils.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+){2})$/i)
  end

  def install
    prefix.install_metafiles

    zsh_function.install Dir["functions/**/*.zsh"].to_h { |path| [path, path.delete_prefix(".zsh")] }

    pkgshare.install Dir["src/*"]
    prefix.install_symlink pkgshare/"init.zsh" => "init"
    bin.install_symlink pkgshare/"install.zsh" => installer_name
  end

  def caveats
    <<~EOS
      To autoload functions, add this to your profile:
        source #{opt_prefix}/init

      or run "#{installer_name}" to configure .zshrc automatically.
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
