class CliUtils < Formula
  desc "Custom utility commands."
  homepage "https://github.com/benmoose/homebrew-cli-utils"
  url "https://github.com/benmoose/homebrew-cli-utils/archive/refs/tags/v0.0.3.tar.gz"
  sha256 "2c0996e392673e76e300c5625045d0e13c96a5610bc70d32ed8d4fd4a088c305"
  license "GPL-3.0-or-later"

  depends_on :macos  
  depends_on "uuidgen"

  def install
    (packageshare/"functions").install Dir["functions/*.zsh"]
  end

  def caveats
    <<EOS
      To load your cli-utils functions, add this to your ~/.zshrc:

      for f in #{HOMEBREW_PREFIX}/share/cli-utils/functions/*.zsh; do
        source "$f"
      done

      Then restart your shell or run: source ~/.zshrc
    EOS
  end

  test do
    system "zsh", "-c", "ls #{pkgshare}/functions"
  end
end
