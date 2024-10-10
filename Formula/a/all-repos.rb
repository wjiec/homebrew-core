class AllRepos < Formula
  include Language::Python::Virtualenv

  desc "Clone all your repositories and apply sweeping changes"
  homepage "https://github.com/asottile/all-repos"
  url "https://files.pythonhosted.org/packages/a6/56/29006be2546b897a5c62a3d4a7e613abf5a3533554d948b0e0af27546f1b/all_repos-1.27.0.tar.gz"
  sha256 "96fea3e34caa004b0770501e6efb93dc49cbca05fb56c2b8b2a85d06fb3a4573"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "eb28bf2194299b1e26438238d93afc1099c7f82a85a5435e9cc22b97f90d8360"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b2fa8c56988879e6fde4225ee508808727b0c0f7e7693478c26fea948ee64650"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "09fc178a99cb173c83ef1de1eac435a6c99ac3bb5c13364212bcdce6b45219f0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6479b239edd3c6fa0d4f1ee7e88fcba6e5f1433ff3a6cc6f20cb87eb73b9eb03"
    sha256 cellar: :any_skip_relocation, sonoma:         "a9297534b052c7ad5262f439df803efffae923493ed8db714d1d75123fd44960"
    sha256 cellar: :any_skip_relocation, ventura:        "6c84d2dda2b192bd3f2c2b46ee7696bf03a2aad1b3500e3fdf1f1a3dc55c51e1"
    sha256 cellar: :any_skip_relocation, monterey:       "ff58b3a8c9be8b05175e3ba556a38dc0a8d8dfd47ace84a86ceb9b3bbf283c1a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "eda91965585b8feabd8c909f3a92687e647befd80901d25e8597bb08dbba6820"
  end

  depends_on "python@3.13"

  resource "identify" do
    url "https://files.pythonhosted.org/packages/29/bb/25024dbcc93516c492b75919e76f389bac754a3e4248682fba32b250c880/identify-2.6.1.tar.gz"
    sha256 "91478c5fb7c3aac5ff7bf9b4344f803843dc586832d5f110d672b19aa1984c98"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/51/65/50db4dda066951078f0a96cf12f4b9ada6e4b811516bf0262c0f4f7064d4/packaging-24.1.tar.gz"
    sha256 "026ed72c8ed3fcce5bf8950572258698927fd1dbda10a5e981cdf0ac37f4f002"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath/"all-repos.json").write <<~EOS
      {
        "output_dir": "out",
        "source": "all_repos.source.json_file",
        "source_settings": {"filename": "repos.json"},
        "push": "all_repos.push.readonly",
        "push_settings": {}
      }
    EOS
    chmod 0600, "all-repos.json"
    (testpath/"repos.json").write <<~EOS
      {"discussions": "https://github.com/Homebrew/discussions"}
    EOS

    system bin/"all-repos-clone"
    assert_predicate testpath/"out/discussions", :exist?
    output = shell_output("#{bin}/all-repos-grep discussions")
    assert_match "out/discussions:README.md", output
  end
end
