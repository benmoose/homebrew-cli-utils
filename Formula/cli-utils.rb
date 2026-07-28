class CliUtils < Formula
  desc "A collection of useful CLI commands."
  homepage "https://github.com/benmoose/homebrew-cli-utils"
  url "https://github.com/benmoose/homebrew-cli-utils/archive/refs/tags/v0.0.6.tar.gz"
  sha256 "a7486586e5874551be0b78d631c4d3525af0735f5563cf3a3aa068c670b27b07"
  license "GPL-3.0-or-later"

  depends_on :macos

  def install
    (pkgshare/"functions").install Dir["functions/*.zsh"]
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
    (testpath/".zshrc").write <<~EOS
      for f in #{pkgshare}/functions/*.zsh; do
        source "$f"
      done
    EOS

    output = shell_output("zsh -c 'source #{testpath}/.zshrc && type com cos rbm uuid'")
    assert_match "com is a shell function", output
    assert_match "cos is a shell function", output
    assert_match "rbm is a shell function", output
    assert_match "uuid is a shell function", output
  end
end
