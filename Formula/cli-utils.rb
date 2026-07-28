class CliUtils < Formula
  desc "A collection of useful Zsh CLI functions."
  homepage "https://github.com/benmoose/homebrew-cli-utils"
  url "https://github.com/benmoose/homebrew-cli-utils/archive/refs/tags/v0.0.9.tar.gz"
  sha256 "e690fabe4509907568fa7d87d3db2fa6915b0989d90f1e636fcd7d1e3e6b3dfc"
  head "https://github.com/benmoose/homebrew-cli-utils.git", branch: "main"
  license "GPL-3.0-or-later"

  depends_on macos: :catalina

  def install
    prefix.install_metafiles

    (zsh_function).install Dir["functions/*.zsh"]
    (share/"#{revision}.zsh").write <<~EOS
      #!/usr/bin/env zsh

      source #{zsh_function}/utils.zsh
      for f in #{zsh_function}/{git,uuid}.zsh; do
        source $f
      done
    EOS
    (opt_share/"#{name}.zsh").install_symlink share/"#{revision}.zsh"
  end

  def caveats
    <<~EOS
      To load your cli-utils functions, add this to your ~/.zshrc:

      source #{opt_share}/cli-utils.zsh

      Then restart your shell or run: source ~/.zshrc
    EOS
  end

  test do
    (testpath/".zshrc").write <<~EOS
      for f in #{zsh_function}/*.zsh; do
        source "$f"
      done
    EOS

    type_out = shell_output("zsh -c 'source #{testpath}/.zshrc && type #{func_names.join(' ')}'")
    func_names.each do |name|
      assert_match("#{name} is a shell function", type_out)
    end

    uuid_out = shell_output("zsh -c 'source #{testpath}/.zshrc && uuid'").rstrip
    assert_match(/^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$/, uuid_out)

    err_out = shell_output("zsh -c 'source #{testpath}/.zshrc && ,err foobar 2>&1'")
    assert_match("foobar\n", err_out)
  end

  private

  def func_names
    %i(com cos rbm uuid)
  end
end
