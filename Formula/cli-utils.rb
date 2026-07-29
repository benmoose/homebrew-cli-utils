class CliUtils < Formula
  desc "Collection of useful Zsh CLI functions"
  homepage "https://github.com/benmoose/homebrew-cli-utils"
  url "https://github.com/benmoose/homebrew-cli-utils/archive/refs/tags/v0.0.12.tar.gz"
  sha256 "66626297b2542481896441456736d49df49d960420b0d0dbb45ddab4e0a6c3f0"
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
      To load your cli-utils functions, add this to your ~/.zshrc:

      source #{opt_share}/#{name}

      Then restart your shell or run `source ~/.zshrc`
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
