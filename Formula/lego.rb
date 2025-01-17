class Lego < Formula
  desc "Let's Encrypt client"
  homepage "https://go-acme.github.io/lego/"
  url "https://github.com/go-acme/lego/archive/v2.7.1.tar.gz"
  sha256 "835fef2148e586ca81cd6116861baaada94f7c0b5bda37dcf14ca666544cb0f9"

  bottle do
    cellar :any_skip_relocation
    sha256 "6c10ab48ffd368c9671ebd95ad2a3f3bdf985ed3e9acf9ef78c0b7be9f7476c0" => :mojave
    sha256 "7732c3c85a06cb894eda1c9b92410263343dd279474e7669a0db4485a734a7f3" => :high_sierra
    sha256 "4a5d02b4d07cb7af7175d33d4736a7bb8464259a2289d106cd2f2e5cb974a748" => :sierra
    sha256 "07ef97bba263b406c16fcd9dadae34f3c02047b4454a72ed742d41f5f5250da6" => :x86_64_linux
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/go-acme/lego").install buildpath.children
    cd "src/github.com/go-acme/lego/cmd/lego" do
      system "go", "build", "-o", bin/"lego", "-ldflags",
             "-X main.version=#{version}"
      prefix.install_metafiles
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/lego -v")
  end
end
