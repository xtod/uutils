# bandwhich

![demo](/imgs/bandwhichdemo.gif)

这是一个 CLI 实用程序，用于按进程、连接和远程 IP/主机名显示当前网络利用率

### bandwhich如何工作?
bandwhich嗅探给定的网络接口并记录 IP 数据包大小，将其与 Linux 上的 /proc 文件系统、macOS 上的 lsof 交叉引用，或在 Windows 上使用 WinApi。它响应终端窗口的大小，如果没有空间，则显示的信息较少。它还将尝试在后台尽最大努力使用反向 DNS 将 ip 解析为其主机名。
### 安装bandwhich

#### 下载预构建的二进制文件
如果您使用的是 linux，则可以从发行版中下载通用二进制文件。

#### Arch Linux

```
pacman -S bandwhich
```

#### Nix/NixOS

bandwhich可以在  [`nixpkgs`](https://github.com/nixos/nixpkgs/blob/master/pkgs/tools/networking/bandwhich/default.nix) 中使用，并且可以安装，例如，使用 nix-env：
```
nix-env -iA nixpkgs.bandwhich
```

#### Void Linux

```
xbps-install -S bandwhich
```

#### Fedora

`bandwhich`可在[COPR](https://copr.fedorainfracloud.org/coprs/atim/bandwhich/)中使用，并且可以通过 DNF 安装：
```
sudo dnf copr enable atim/bandwhich -y && sudo dnf install bandwhich
```

#### macOS/Linux (using Homebrew)

```
brew install bandwhich
```

#### FreeBSD

```
pkg install bandwhich
```

or

```
cd /usr/ports/net-mgmt/bandwhich && make install clean
```

#### Windows / 其他 Linux 版本

`bandwhich`可以使用 Rust 包管理器 cargo 进行安装。如果您使用的是 linux，它可能在您的发行版存储库中，或者您可以通过 [rustup](https://rustup.rs/) 安装它。您可以在[此处](https://doc.rust-lang.org/book/ch01-01-installation.html)找到其他安装说明。

支持的最低 Rust 版本为 1.39.0。

```
cargo install bandwhich
```

##### 在 Linux 上使用 cargo 安装后
Cargo 将 `bandwhich` 安装到 `~/.cargo/bin/bandwhich`，但你需要 root 权限才能运行 `bandwhich`。要解决此问题，有以下几种选择：

- 为可执行文件授予提升的权限： ``sudo setcap cap_sys_ptrace,cap_dac_read_search,cap_net_raw,cap_net_admin+ep $(which bandwhich)`` 
- 运行 `sudo ~/.cargo/bin/bandwhich`，而不仅仅是 `bandwhich`
- 创建一个符号链接： `sudo ln -s ~/.cargo/bin/bandwhich /usr/local/bin/` （或根 PATH 上的另一个路径）
- 设置 root 的 PATH 以匹配您自己的 PATH： `sudo env "PATH=$PATH" bandwhich`
- 告诉 sudo 使用用户的环境变量： `sudo -E bandwhich`
- 将所需的目标目录传递给 cargo： `sudo cargo install bandwhich --root /usr/local/bin/`

##### 在 Windows 上与 cargo 一起安装后

您可能需要先安装 [npcap](https://nmap.org/npcap/)  才能在 Windows 上捕获数据包。

#### OpenWRT

要在 OpenWRT 上安装  `bandwhich`，您需要编译一个适合其处理器架构的二进制文件。这可能意味着，例如，如果您正在 `x86_64` 上工作，而 OpenWRT 安装在 `arm7` 上，则必须进行交叉编译。

以下是在这种情况下交叉编译的示例：

- 使用 `uname -m` 检查路由器的处理器架构
- 克隆 bandwhich 仓库 `git clone https://github.com/imsnif/bandwhich`
- 使用 `cargo install cross` 安装`cross`
- 使用`cross build --target armv7-unknown-linux-musleabihf`构建`bandwhich`
- 通过运行 `scp bandwhich root@192.168.1.1:~/`（此处 192.168.1.1 将是路由器的 IP 地址），使用  `scp` 将二进制文件从  `target/armv7-unknown-linux-musleabihf/debug/bandwhich` 复制到路由器。
- 最后使用 ssh 进入路由器，直接使用 `./bandwhich`运行二进制文件

### bandwhich使用方法
```
使用:
    bandwhich [参数] [选项]

参数:
    -a, --addresses            仅显示远程地址表
    -c, --connections          仅显示连接表
    -h, --help                 打印帮助信息
    -n, --no-resolve           不要尝试将 IP 解析为其主机名
    -p, --processes            仅显示进程表
    -r, --raw                  机器友好型输出
    -s, --show-dns             显示 DNS 查询
    -t, --total-utilization    显示总（累计）使用量
    -V, --version              打印版本信息

选项:
    -i, --interface <interface>    要侦听的网络接口，例如eth0
    -d, --dns-server <dns-server>    要使用的 dns 服务器 ip，而不是系统默认的
```

请注意，由于 `bandwhich` 会嗅探网络数据包，因此它需要 root 权限 - 因此您可能希望将其与（例如）`sudo` 一起使用。

在 Linux 上，您可以为 `bandwhich` 二进制文件提供永久功能来使用所需的权限，这样您就不再需要使用 `sudo bandwhich`

```bash
sudo setcap cap_sys_ptrace,cap_dac_read_search,cap_net_raw,cap_net_admin+ep `which bandwhich`
```

`cap_sys_ptrace,cap_dac_read_search` 为 `bandwhich` 提供了列出 `/proc/<pid>/fd/` 并解析该目录中的符号链接的能力。它需要此功能来确定哪个打开的端口属于哪个进程。 `cap_net_raw,cap_net_admin` 为 `bandwhich` 提供了捕获系统上数据包的功能。

### raw_mode
`bandwhich`还支持一种更容易解析的模式，该模式可以通过管道传输或重定向到文件。例如：
```
bandwhich --raw | grep firefox
```

要设置您的开发环境：
1. 克隆项目
2. `cargo run`，或者如果你更喜欢`cargo run -- -i <network interface name>`（你通常可以通过 `ifconfig` 或 `iwconfig` 找到名称）。您可能需要 root 权限才能运行此应用程序，因此请务必使用（例如）sudo。

运行测试: `cargo test`

请注意，目前测试不会测试 os 层（'os' 文件夹中的任何内容）。

如果您遇到困难、不确定如何处理某个问题或需要一些指导，欢迎您联系：aram@poor.dev

### 许可证
MIT

_https://github.com/imsnif/bandwhich_