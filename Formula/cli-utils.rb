class CliUtils < Formula
  desc "Custom utility commands."
  homepage "https://github.com/benmoose/homebrew-cli-utils"
  url "https://github.com/benmoose/homebrew-cli-utils/archive/refs/tags/v0.0.4.tar.gz"
  sha256 "4248d2f8b2226546d9a0196f8524e4c75c9fb43644a613dfabe0d72e7a8e8bcf"
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
