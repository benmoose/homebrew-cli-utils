class CliUtils < Formula
  desc "Collection of useful Zsh CLI functions"
  homepage "https://github.com/benmoose/homebrew-cli-utils"
  url "https://github.com/benmoose/homebrew-cli-utils/archive/refs/tags/v0.0.66.tar.gz"
  sha256 "c98c612b8615e06a1f95959ca020a637a97d9021ce2c5697748378577940cd65"
  license "GPL-3.0-or-later"
  head "https://github.com/benmoose/homebrew-cli-utils.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+){2})$/i)
  end

  def install
    prefix.install_metafiles
    zsh_function.install Dir["src/private/*"]
    zsh_function.install Dir["src/public/*"]

    pkgshare.install "src/init.zsh"

    # inreplace("src/install.zsh", "__INIT_PATH__", "#{opt_pkgshare}/init.zsh")
  end

  def post_install
    dotfile = Pathname.new(Dir.home) / ".zshrc"
    source_line = %Q(source "#{opt_pkgshare}/init.zsh")

    ohai "dotfile: (#{dotfile.exist?}) #{dotfile}"
    ohai "source: #{source_line}"
    return unless dotfile.exist?
    return if dotfile.read.include?(source_line)

    dotfile.open("a") do |f|
      f.puts ""
      f.puts "# #{full_name}"
      f.puts source_line
    end

    ohai "Added #{name} to #{dotfile}. Restart your shell or run: `source #{zshrc}`"
  end

  def caveats
    <<~EOS
      To load #{name} shared variables, add the following to your .zshrc:
        source "#{opt_pkgshare}/init.zsh"
    EOS
  end

  # test do
  #   assert_match("builtin autoload", shell_output("zsh -c 'source #{opt_pkgshare} uuid && $functions[uuid]'"))

  #   uuid_out = shell_output("zsh -c 'uuid'").rstrip
  #   assert_match(/^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$/, uuid_out)
  # end
end
