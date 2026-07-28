class CliUtils < Formula
  desc "Custom utility commands."
  homepage "https://github.com/benmoose/homebrew-cli-utils"
  url "https://github.com/benmoose/homebrew-cli-utils/archive/refs/tags/v0.0.5.tar.gz"
  sha256 "78f27ffefb70fc6c308652adc491891c53b6e0ba9b27c419cecf7c5ce83a2baf"
  license "GPL-3.0-or-later"

  depends_on :macos

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
