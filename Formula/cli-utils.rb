class CliUtils < Formula
  desc "Collection of useful Zsh CLI functions"
  homepage "https://github.com/benmoose/homebrew-cli-utils"
  url "https://github.com/benmoose/homebrew-cli-utils/archive/refs/tags/v0.0.14.tar.gz"
  sha256 "7577c01218eca04d6a58d29d076a6dea0653ade699eab51188ed02fac8583603"
  license "GPL-3.0-or-later"
  head "https://github.com/benmoose/homebrew-cli-utils.git", branch: "main"

  depends_on macos: :catalina

  def install
    prefix.install_metafiles

    cd "src" do
      pkgshare.install Dir["./functions/*.zsh"]
      pkgshare.install "./global.zsh"
    end

    (share/".zshrc").write <<~EOS
      # #{name} v#{version.to_s}
      for _f in #{pkgshare}/*.zsh; do
        source ${_f}
      done
      unset _f
    EOS
  end

  def caveats
    <<~EOS
      If the functions are not found automatically, add this to your ~/.zshrc

      `source #{opt_share}/.zshrc`

      Then restart your terminal or run `source ~/.zshrc`.
    EOS
  end

  test do
    type_out = shell_output("zsh -c 'source #{share}/.zshrc && type #{func_names.join(" ")}'")
    func_names.each do |fn|
      assert_match("#{fn} is a shell function", type_out)
    end

    uuid_out = shell_output("zsh -c 'source #{share}/.zshrc && uuid'").rstrip
    assert_match(/^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$/, uuid_out)
  end

  private

  def func_names
    [:com, :cos, :rbm, :uuid]
  end
end
