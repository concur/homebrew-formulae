class Dvm < Formula
  desc "Manage multiple docker client versions"
  homepage "https://github.com/getcarina/dvm"
  url "https://github.com/getcarina/dvm/archive/0.3.1.tar.gz"
  sha256 "8c515d69e7ae4bda347eb54d55625c4533aadf0960f54d7c263b739b008b1caa"
  head "https://github.com/getcarina/dvm.git"

  bottle :unneeded

  resource "helper" do
    url "https://download.getcarina.com/dvm/0.3.1/Darwin/x86_64/dvm-helper"
    sha256 "a01337f80b44eb6f6e64e370f57c409027182a3ea14ce5a0f71ebe8c9b19d52f"
  end

  def install
    prefix.install "dvm.sh"
    bash_completion.install "bash_completion" => "dvm"
    mkdir "dvm/dvm-helper" do
      resource("helper").stage do
        prefix.install "dvm-helper" => "dvm/dvm-helper"
      end
    end
  end

  def caveats; <<-EOS.undent
    Your $DVM_DIR will be $(brew --prefix dvm). No need to export the
    environment variable.

    Add the following to #{shell_profile} or your desired shell
    configuration file:

      . $(brew --prefix dvm)/dvm.sh

    You can set $DVM_DIR to any location, but leaving it unchanged from
    #{prefix} will destroy any dvm-installed Docker installations
    upon upgrade/reinstall.

    Type `dvm help` for further information.
  EOS
  end

  test do
    output = pipe_output("#{prefix}/dvm/dvm-helper/dvm-helper 2>&1")
    assert_no_match /No such file or directory/, output
    assert_no_match /dvm: command not found/, output
    assert_match /Docker Version Manager/, output
  end
end
