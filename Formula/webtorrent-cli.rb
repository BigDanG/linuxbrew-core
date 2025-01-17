require "language/node"

class WebtorrentCli < Formula
  desc "Command-line streaming torrent client"
  homepage "https://webtorrent.io/"
  url "https://registry.npmjs.org/webtorrent-cli/-/webtorrent-cli-2.0.2.tgz"
  sha256 "d89d76321f03be9d23c68ed8b8eeaa633e6e6dd6cb86227054edaef0338ff23d"

  bottle do
    cellar :any_skip_relocation
    sha256 "aa97bf25c28bbcb3efceca2a37aa874822f454d0045e082b72b36fbae08591d5" => :mojave
    sha256 "5e25f9516ea33ada1abbe47610ebd8c51e41cad0b70bc8652c72c85a70a16014" => :high_sierra
    sha256 "a3fb80d7afa4416881df76b8591fd3c254a5a373741b493eaa78f88efd9e9a6c" => :sierra
    sha256 "505c374f8d399df52479aed3ae5217669b2d579ddefc10cc532d4dd94feac187" => :x86_64_linux
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    magnet_uri = <<~EOS.gsub(/\s+/, "").strip
      magnet:?xt=urn:btih:9eae210fe47a073f991c83561e75d439887be3f3
      &dn=archlinux-2017.02.01-x86_64.iso
      &tr=udp://tracker.archlinux.org:6969
      &tr=https://tracker.archlinux.org:443/announce
    EOS

    assert_equal <<~EOS.chomp, shell_output("#{bin}/webtorrent info '#{magnet_uri}'")
      {
        "xt": "urn:btih:9eae210fe47a073f991c83561e75d439887be3f3",
        "dn": "archlinux-2017.02.01-x86_64.iso",
        "tr": [
          "https://tracker.archlinux.org:443/announce",
          "udp://tracker.archlinux.org:6969"
        ],
        "infoHash": "9eae210fe47a073f991c83561e75d439887be3f3",
        "name": "archlinux-2017.02.01-x86_64.iso",
        "announce": [
          "https://tracker.archlinux.org:443/announce",
          "udp://tracker.archlinux.org:6969"
        ],
        "urlList": []
      }
    EOS
  end
end
