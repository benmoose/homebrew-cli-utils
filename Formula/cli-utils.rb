class CliUtils < Formula
  desc "Collection of useful Zsh CLI functions"
  homepage "https://github.com/benmoose/homebrew-cli-utils"
  url "https://github.com/benmoose/homebrew-cli-utils/archive/refs/tags/v0.0.16.tar.gz"
  sha256 "9002a284e2cd6eba949297771d5bf8c1cfd1ad519a71e148638b419029676da4"
  license "GPL-3.0-or-later"
  head "https://github.com/benmoose/homebrew-cli-utils.git", branch: "main"

  def install
    prefix.install_metafiles

    pkgshare.install Dir["functions/private/_*"]
    pkgshare.install Dir["functions/public/*"]
  end

  def post_install
    system "autoload", "-Uz", "_require", func_names.join(" ")
  end

  def caveats
    ohai <<~EOS
      Add this to your .zshrc:

        fpath=(#{opt_pkgshare} $fpath)
        autoload -Uz _require #{func_names.join(" ")}
    EOS
  end

  test do
    func_names.each do |fn|
      assert_match("builtin autoload", shell_output("zsh -c '$functions[#{fn}]'"))
    end

    # uuid_out = shell_output("zsh -c 'uuid'").rstrip
    # assert_match(/^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$/, uuid_out)
  end

  private

  def func_names
    Dir.glob("[^_]*", base: opt_pkgshare)
  end
end
