class CliUtils < Formula
  desc "Collection of useful Zsh CLI functions"
  homepage "https://github.com/benmoose/homebrew-cli-utils"
  url "https://github.com/benmoose/homebrew-cli-utils/archive/refs/tags/v0.0.72.tar.gz"
  sha256 "0722af0f0900bdda24b32bd4ed59fb3fbde4cb07b142da536d2e4cb2755681e2"
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

    pkgshare.install "src/init.sh"
    prefix.install_symlink pkgshare/"init.zsh"

    libexec.install "src/install.zsh"
    bin.install_symlink libexec/"install.zsh" => "#{name}-install"
  end

  def caveats
    source_path=(opt_pkgshare/"init.zsh").relative_path_from(opt_prefix)

    <<~EOS
    To autoload #{name} functions, add the following to your .zshrc:
      source #{name}-init
    or run \`install-#{name}\` to install automatically
    EOS
  end

  test do
    expect(formula.pkgshare).to be_a_directory
  end
end
