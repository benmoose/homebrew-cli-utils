class CliUtils < Formula
  desc "A collection of useful Zsh CLI functions."
  homepage "https://github.com/benmoose/homebrew-cli-utils"
  url "https://github.com/benmoose/homebrew-cli-utils/archive/refs/tags/v0.0.8.tar.gz"
  sha256 "53472ae9064844d154f6183ec56a3fafa5f9d6d5e98d6cba691562eb869d9fb6"
  license "GPL-3.0-or-later"

  def install
    (pkgshare/"functions").install Dir["functions/*.zsh"]
  end

  def caveats
    <<~EOS
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
        source "${f}"
      done
    EOS

    # system "source" "#{testpath}/.zshrc"
    func_names.each do |name|
      assert_match "#{name} is a shell function", shell_output("zsh -c 'type #{name}'")
    end

    uuid_out = shell_output("zsh -c 'uuid'")
    assert_match(/[09-af]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}/, uuid_out)

    err_out = shell_out("zsh -c ',err foobar'")
    assert_match("foobar\n", err_out)
  end

  private

  private_class_method def self.func_names
    %i(com cos rbm uuid)
  end
end
