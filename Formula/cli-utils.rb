class CliUtils < Formula
  desc "Collection of useful Zsh CLI functions"
  homepage "https://github.com/benmoose/homebrew-cli-utils"
  url "https://github.com/benmoose/homebrew-cli-utils/archive/refs/tags/v0.0.13.tar.gz"
  sha256 "504d81234e3637794f8c6289d4bab78935a91ab745a5c615498ce7473e4826d2"
  license "GPL-3.0-or-later"
  head "https://github.com/benmoose/homebrew-cli-utils.git", branch: "main"

  depends_on macos: :catalina

  def install
    prefix.install_metafiles

    zsh_function.install Dir["src/functions/*.zsh"]
    zsh_function.install "src/global.zsh" => "_global.zsh"

    (share/name).write <<~EOS
      # #{name} v#{version.to_s}      
      source #{zsh_function}/_global.zsh
      for f in #{zsh_function}/*.zsh; do
        source ${f}
      done
    EOS
  end

  def caveats
    <<~EOS
      If the functions are not found automatically, add this to your ~/.zshrc

      \tsource #{opt_share}/#{name}

      Then restart your terminal or run `source ~/.zshrc`.
    EOS
  end

  test do
    type_out = shell_output("zsh -c 'source #{share}/#{name} && type #{func_names.join(" ")}'")
    func_names.each do |fn|
      assert_match("#{fn} is a shell function", type_out)
    end

    uuid_out = shell_output("zsh -c 'source #{share}/#{name} && uuid'").rstrip
    assert_match(/^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$/, uuid_out)

    err_out = shell_output("zsh -c 'source #{share}/#{name} && ,err foobar 2>&1'")
    assert_match("foobar\n", err_out)
  end

  private

  def func_names
    [:com, :cos, :rbm, :uuid]
  end
end
