# Documentation: https://docs.brew.sh/Formula-Cookbook
#                https://docs.brew.sh/rubydoc/Formula
# PLEASE REMOVE ALL GENERATED COMMENTS BEFORE SUBMITTING YOUR PULL REQUEST!
class CliUtils < Formula
  desc "Custom utility commands."
  homepage "https://github.com/benmoose/homebrew-cli-utils"
  url "https://github.com/benmoose/homebrew-cli-utils/archive/refs/tags/v0.0.1.tar.gz"
  sha256 "2a0caa7d43808097532c99640a90e6fa8a28d74cc62497bd31b1f2cfbcba8c18"
  version "0.0.1"
  license "GPL-3.0"

  depends_on :macos

  depends_on "jq"
  depends_on "gh"
  depends_on "tree"
  depends_on "uuidgen"

  # depends_on "cmake" => :build

  # Additional dependency
  # resource "" do
  #   url ""
  #   sha256 ""
  # end

  def install
    libexec.install "cli-utils.sh"

    commands = ["uuid"]
    commands.each do |cmd|
      bin.install_symlink libexec/"cli-utils.sh" => cmd
    end
  end

  test do
    assert_match /[a-z0-9-]+/, shell_output("#{bin}/uuid")
  end
end
