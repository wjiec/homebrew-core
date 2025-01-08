class BashUnit < Formula
  desc "Bash unit testing enterprise edition framework for professionals"
  homepage "https://github.com/pgrange/bash_unit"
  url "https://github.com/pgrange/bash_unit/archive/refs/tags/v2.3.2.tar.gz"
  sha256 "368d1712d4c265909a5039ea91180dba1db5b15b5a02cf24cfb3b7547c0e9150"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "34176de04475a95302410fbb0d9deb4078f034bbef39b17b2fe16c1ce48ffa35"
  end

  uses_from_macos "bc" => :test

  def install
    bin.install "bash_unit"
    man1.install "docs/man/man1/bash_unit.1"
  end

  test do
    (testpath/"test.sh").write <<~SHELL
      test_addition() {
        RES="$(echo 2+2 | bc)"
        assert_equals "${RES}" "4"
      }
    SHELL
    assert "addition", shell_output("#{bin}/bash_unit test.sh")
  end
end
