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
    libexec.install "functions/init.sh"
    
    (bin/"init-cli-utils").write_env_script libexec/"init.sh", [pkgshare], fpath: ENV.fetch("FPATH", nil)
  end

  def caveats
    <<~EOS
      Add this to your .zshrc:

        ./init-cli-utils.sh #{opt_pkgshare}
    EOS
  end

  # test do
  #   assert_match("builtin autoload", shell_output("zsh -c 'source #{opt_pkgshare} uuid && $functions[uuid]'"))

  #   uuid_out = shell_output("zsh -c 'uuid'").rstrip
  #   assert_match(/^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$/, uuid_out)
  # end
end
