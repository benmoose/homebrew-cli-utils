class CliUtils < Formula
  desc "Collection of useful Zsh CLI functions"
  homepage "https://github.com/benmoose/homebrew-cli-utils"
  url "https://github.com/benmoose/homebrew-cli-utils/archive/refs/tags/v0.0.97.tar.gz"
  sha256 "dbccceefc871abe3848c2de691f19b6910ee8c2d58480c6c0ed86c728c4f7982"
  license "GPL-3.0-or-later"
  head "https://github.com/benmoose/homebrew-cli-utils.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+){2})$/i)
  end

  def install
    prefix.install_metafiles

    pkgshare.install Dir["src/*"]
    prefix.install_symlink pkgshare/"init.zsh" => "init"
    bin.install_symlink pkgshare/"install.zsh" => installer_name

    zsh_function.install Pathname.glob("functions/**/*.zsh").to_h do |path|
        [path, path.basename.sub_ext("")]
    end
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
