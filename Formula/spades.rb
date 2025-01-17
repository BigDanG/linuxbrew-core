class Spades < Formula
  desc "De novo genome sequence assembly"
  homepage "http://cab.spbu.ru/software/spades/"
  url "http://cab.spbu.ru/files/release3.13.0/SPAdes-3.13.0.tar.gz"
  mirror "https://github.com/ablab/spades/releases/download/v3.13.0/SPAdes-3.13.0.tar.gz"
  sha256 "c63442248c4c712603979fa70503c2bff82354f005acda2abc42dd5598427040"
  revision 1

  bottle do
    cellar :any
    sha256 "6eff79211afd0a5f2a3194db28a630bfa53cec5b968dc810e65bbaefce55fae4" => :mojave
    sha256 "ef7d029efa28d81c236a428f40c0780b074827b50e5618cc328b4cfffdc7e579" => :high_sierra
    sha256 "8418d4226f398f2853500eb3fea5788d58b392202101934a4fba502f7c77efcd" => :sierra
    sha256 "a198e95082ad7fa73c0e1ec501341d2924280802ff954db00834095a34739d81" => :x86_64_linux
  end

  depends_on "cmake" => :build
  depends_on "gcc"
  unless OS.mac?
    depends_on "bzip2"
    depends_on "python@2" => :test
  end

  fails_with :clang # no OpenMP support

  def install
    # Reduce memory usage below 4 GB for Circle CI.
    ENV["MAKEFLAGS"] = "-j2" if ENV["CIRCLECI"]

    mkdir "src/build" do
      system "cmake", "..", *std_cmake_args
      system "make", "install"
    end
  end

  test do
    assert_match "TEST PASSED CORRECTLY", shell_output("#{bin}/spades.py --test")
  end
end
