class CliUtils < Formula
  desc "Collection of useful Zsh CLI functions"
  homepage "https://github.com/benmoose/homebrew-cli-utils"
  url "https://github.com/benmoose/homebrew-cli-utils/archive/refs/tags/v0.0.71.tar.gz"
  sha256 "ac5e2c5a72b4095ebbc11e87a8127401810e5ffe3bdfb0b315658e4dc093ff39"
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
    
    inreplace "src/init.zsh", "__FN_DIR__", zsh_function
    libexec.install Dir["src/*.zsh"]

    bin.install_symlink libexec/"install.zsh" => "#{name}-install"
  end

  def caveats
    <<~EOS
      To load #{name} shared variables, run:
        #{name}-install
      which adds the following to your .zshrc:
        source "#{opt_pkgshare}/init.zsh"
    EOS
  end

  test do
    expect(formula.pkgshare).to be_a_directory
  end
end
