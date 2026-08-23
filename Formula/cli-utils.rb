class CliUtils < Formula
  desc "Collection of useful Zsh CLI functions"
  homepage "https://github.com/benmoose/homebrew-cli-utils"
  url "https://github.com/benmoose/homebrew-cli-utils/archive/refs/tags/v0.0.67.tar.gz"
  sha256 "4c353c0b08e0193e0cc457322cbed936cb6c92240a3e37dc35d2a15089918515"
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

    inreplace "src/install.zsh", "__INIT_PATH__", "#{opt_pkgshare}/init.zsh"
    libexec.install "src/install.zsh"
    pkgshare.install "src/init.zsh"
  end

  def post_install
    dotfile = Pathname.new(Dir.home) / ".zshrc"
    ohai "dotfile: (#{dotfile.exist?}) #{dotfile}"
    real_dotfile = Pathname.new(Etc.getpwuid(Process.uid).dir) / ".zshrc"
    ohai "real_home: (#{real_dotfile.exist?}) #{real_dotfile}"
    source_line = %Q(source "#{opt_pkgshare}/init.zsh")

    # Bail quietly if user does not have .zshrc
    return unless dotfile.exist?

    ohai "source: #{source_line}"

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
