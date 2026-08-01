class CliUtils < Formula
  desc "Collection of useful Zsh CLI functions"
  homepage "https://github.com/benmoose/homebrew-cli-utils"
  url "https://github.com/benmoose/homebrew-cli-utils/archive/refs/tags/v#{version}.tar.gz"
  sha256 "9002a284e2cd6eba949297771d5bf8c1cfd1ad519a71e148638b419029676da4"
  version "0.0.16"
  license "GPL-3.0-or-later"
  head "https://github.com/benmoose/homebrew-cli-utils.git", branch: "main"

  def install
    prefix.install_metafiles

    pkgshare.install Dir["functions/private/_*"]
    pkgshare.install Dir["functions/public/*"]
  end

  def caveats
    <<~EOS
      Add this to your .zshrc:

        fpath=(#{opt_pkgshare} $fpath)
        autoload -Uz _require #{pub_fn.inspect}
    EOS
  end

  test do
    fpath=(opt_pkgshare $fpath)
    assert_match("builtin autoload", shell_output("zsh -c 'autoload -Uz uuid; $functions[uuid]'"))

    uuid_out = shell_output("zsh -c 'uuid'").rstrip
    assert_match(/^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$/, uuid_out)
  end

  private

  def pub_fn
    cd pkgshare do
      Dir.glob("[^_][a-z]+")
    end
  end
end
