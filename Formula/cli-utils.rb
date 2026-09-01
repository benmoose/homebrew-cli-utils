class CliUtils < Formula
  desc "Collection of useful Zsh CLI functions"
  homepage "https://github.com/benmoose/homebrew-cli-utils"
  url "https://github.com/benmoose/homebrew-cli-utils/archive/refs/tags/v0.0.104.tar.gz"
  sha256 "abba943c5f2b4421bd2725a28aff7eb71035e3c31f9ba123576d770c7bd3a115"
  license "GPL-3.0-or-later"
  head "https://github.com/benmoose/homebrew-cli-utils.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+){2})$/i)
  end

  def install
    prefix.install_metafiles

    zsh_function.install Pathname.glob("functions/**/*.zsh").to_h { |path| [path, path.basename.sub_ext('')] }

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
