class CAres < Formula
  desc "Asynchronous DNS library"
  homepage "https://c-ares.haxx.se/"
  url "https://c-ares.haxx.se/download/c-ares-1.17.1.tar.gz"
  sha256 "d73dd0f6de824afd407ce10750ea081af47eba52b8a6cb307d220131ad93fc40"
  license "MIT"
  head "https://github.com/c-ares/c-ares.git"

  livecheck do
    url :homepage
    regex(/href=.*?c-ares[._-](\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    cellar :any
    sha256 "332c3557151a1fc789f6cd075219271800e01ee97c75dd2c62e8d58e8fa28ae4" => :big_sur
    sha256 "72a7232d82c7601576bd2af4271157ee34ff478f1cd7febe5c144254ec5e9e07" => :catalina
    sha256 "cd4a1354a3658e804caf1b24a33a40078948d3f9ed9413cb4f32e56045ef244d" => :mojave
    sha256 "14b1bbb8bced1bde8b3a8beb5e3e35fcb65a1dec45393c37cc0533f67d41ec8b" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "ninja" => :build

  def install
    mkdir "build" do
      system "cmake", "..", "-GNinja", *std_cmake_args
      system "ninja"
      system "ninja", "install"
    end
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <stdio.h>
      #include <ares.h>

      int main()
      {
        ares_library_init(ARES_LIB_INIT_ALL);
        ares_library_cleanup();
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-L#{lib}", "-lcares", "-o", "test"
    system "./test"
  end
end
