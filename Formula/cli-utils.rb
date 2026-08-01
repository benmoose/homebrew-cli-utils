class CliUtils < Formula
  desc "Collection of useful Zsh CLI functions"
  homepage "https://github.com/benmoose/homebrew-cli-utils"
  url "https://github.com/benmoose/homebrew-cli-utils/archive/refs/tags/v0.0.15.tar.gz"
  sha256 "4b4f49c5315daee505b3b9768ca0886af14ef3f89b319de2a9555fa1a5e278ec"
  license "GPL-3.0-or-later"
  head "https://github.com/benmoose/homebrew-cli-utils.git", branch: "main"

  def install
    prefix.install_metafiles
    
    zsh_function.install Dir["./src/functions/private/_*"]
    zsh_function.install Dir["./src/functions/public/*"]
  end

  def caveats
    ohai zshrc_message
    # autoload -Uz _require #{function_dir}/*(:t)
  end

  test do
    func_names.each do |fn|
      assert_match("builtin autoload", shell_output("zsh -c '$+functions[#{fn}]'"))
    end

    uuid_out = shell_output("zsh -c 'uuid'").rstrip
    assert_match(/^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$/, uuid_out)
  end

  private

  def function_dir
    "#{HOMEBREW_PREFIX}/share/#{name}/zsh/site-functions"
  end

  def func_names
    [:com, :cos, :uuid]
  end

  def zshrc_message
    <<~EOS
      Add this to your ~/.zshrc

      if [[ -z ${fpath[(r)#{function_dir}]} ]]; then
        fpath=("#{function_dir}" $fpath)    
        autoload -Uz _require com cos uuid
      fi
        
      Then restart your terminal or run `source ~/.zshrc`
    EOS
  end
end
