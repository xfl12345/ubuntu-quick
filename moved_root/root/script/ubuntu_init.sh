#!/usr/bin/env bash
set -e
mkdir -p /mnt/justsave
mkdir -p /mnt/tmp

sed -i 's/^    xterm-color) color_prompt=yes;;$/    xterm-color|*-256color) color_prompt=yes;;/' ~/.bashrc


apt update
apt install -y apt-transport-* ca-certificates software-properties-common gnupg curl wget lsb-release

#cat <<< EOF >> /etc/fstab
##/dev/disk/by-uuid/040e8ea4-2807-471e-bcd9-1dcdf0d7eabd /mnt/disk/raid/md0 ext4 defaults 0 2
##/mnt/disk/raid/md0/justsave                 /mnt/justsave    none    bind      0      0
# <file system>                             <mount point>    <type>  <options> <dump> <pass>
#/mnt/justsave/moved_root/home               /home            none    bind      0      0
#/mnt/justsave/moved_root/var/lib/docker     /var/lib/docker  none    bind      0      0
#/mnt/justsave/moved_root/root               /root            none    bind      0      0
#EOF

export CURRENT_DISTRIB_CODENAME="$(cat /etc/lsb-release  | grep 'DISTRIB_CODENAME' | cut -d'=' -f 2)"
export CURRENT_DISTRIB_ID="$(cat /etc/lsb-release  | grep 'DISTRIB_ID' | cut -d'=' -f 2)"
ubuntu_moved_source_message='# Ubuntu sources have moved to /etc/apt/sources.list.d/ubuntu.sources'
ARCH="$(uname -m)"
apt_config=""
if [[ "$ARCH" == "x86_64" ]]; then
    apt_config=$(cat << EOF
Types: deb
URIs: https://mirrors.aliyun.com/ubuntu/
Suites: ${CURRENT_DISTRIB_CODENAME} ${CURRENT_DISTRIB_CODENAME}-updates ${CURRENT_DISTRIB_CODENAME}-backports ${CURRENT_DISTRIB_CODENAME}-security
Components: main restricted universe multiverse
Signed-By: /usr/share/keyrings/ubuntu-archive-keyring.gpg

Types: deb
URIs: http://archive.ubuntu.com/ubuntu/
Suites: ${CURRENT_DISTRIB_CODENAME} ${CURRENT_DISTRIB_CODENAME}-updates ${CURRENT_DISTRIB_CODENAME}-backports
Components: main restricted universe multiverse
Signed-By: /usr/share/keyrings/ubuntu-archive-keyring.gpg

Types: deb
URIs: http://security.ubuntu.com/ubuntu/
Suites: ${CURRENT_DISTRIB_CODENAME}-security
Components: main restricted universe multiverse
Signed-By: /usr/share/keyrings/ubuntu-archive-keyring.gpg

EOF
)
else
    apt_config=$(cat << EOF
Types: deb
URIs: https://mirrors.aliyun.com/ubuntu-ports/ http://ports.ubuntu.com/ubuntu-ports/
Suites: ${CURRENT_DISTRIB_CODENAME} ${CURRENT_DISTRIB_CODENAME}-updates ${CURRENT_DISTRIB_CODENAME}-backports ${CURRENT_DISTRIB_CODENAME}-security
Components: main restricted universe multiverse
Signed-By: /usr/share/keyrings/ubuntu-archive-keyring.gpg

EOF
)
fi
[[ "$CURRENT_DISTRIB_ID" == "Ubuntu" ]] && test -e /etc/apt/sources.list && [[ "$(cat /etc/apt/sources.list | head -n1)" != "$ubuntu_moved_source_message" ]] && echo "$ubuntu_moved_source_message" > /etc/apt/sources.list && echo -e "${apt_config}" > /etc/apt/sources.list.d/ubuntu.sources



MY_K8S_VERSION='v1.33'
curl -fsSL 'https://pkgs.k8s.io/core:/stable:/'"${MY_K8S_VERSION}"'/deb/Release.key' | sudo gpg --dearmor -o /usr/share/keyrings/kubernetes-apt-keyring.gpg
test -e /etc/apt/sources.list.d/k8s.sources || cat << EOF > /etc/apt/sources.list.d/k8s.sources
Types: deb
URIs: https://mirrors.aliyun.com/kubernetes-new/core/stable/${MY_K8S_VERSION}/deb/ https://pkgs.k8s.io/core:/stable:/${MY_K8S_VERSION}/deb/
Suites: /
Components:
Signed-By: /usr/share/keyrings/kubernetes-apt-keyring.gpg

EOF

apt remove -y docker.io docker-doc docker-compose podman-docker containerd runc
test -e /etc/apt/sources.list.d/docker.sources || cat << EOF > /etc/apt/sources.list.d/docker.sources
Enabled: yes
Types: deb
URIs: https://mirrors.aliyun.com/docker-ce/linux/ubuntu https://download.docker.com/linux/ubuntu
Suites: ${CURRENT_DISTRIB_CODENAME}
Components: stable
Signed-By:
 -----BEGIN PGP PUBLIC KEY BLOCK-----
 .
 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
 YT90qFF93M3v01BbxP+EIY2/9tiIPbrd
 =0YYh
 -----END PGP PUBLIC KEY BLOCK-----
EOF

test -e /etc/apt/preferences.d/cockpit.pref || cat << EOF > /etc/apt/preferences.d/cockpit.pref
Package: cockpit*
Pin: origin "archive.ubuntu.com", release n=noble-backports
Pin-Priority: 990

EOF

apt update
apt install -y ubuntu-standard # busybox-static mtr-tiny
apt install -y apt-file apt-utils tar zip unzip 7zip xzip xz-utils net-tools sudo bind9-dnsutils safe-rm tree
apt install -y wireguard-tools
apt-file update
apt install -y debootstrap fakeroot screen systemd-timesyncd

apt install -y gcc make cmake gdb m4 autoconf automake git bc bison flex pahole cpio rsync kmod
apt install -y python3 python3-dev python3-setuptools python3-pip pipx
apt install -y fonts-noto-mono fonts-noto-extra fonts-noto-cjk-extra fonts-unifont

apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin docker-ce-rootless-extras cgroupfs-mount cgroup-lite

# sed -i 's/^disabled_plugins = $"cri"$/#&/' /etc/containerd/config.toml
# kubeadm init
# sed -i 's#memorySwap: {}#memorySwap:\n  swapBehavior: LimitedSwap\nfailSwapOn: false#' /var/lib/kubelet/config.yaml
# kubeadm init --skip-phases=preflight,certs,kubeconfig,etcd,control-plane,kubelet-start

apt install -y psensor psensor-server lm-sensors
apt install -y adb fonts-font-awesome
apt install -y drm-info libdrm-dev libdrm2

mkdir -p /etc/dnsmasq.d
test -e /etc/dnsmasq.d/50-my-dns.conf || cat << EOF >> /etc/dnsmasq.d/50-my-dns.conf
dns-forward-max=9999999
strict-order
no-resolv

server=/headscale.internal/100.100.100.100#53

# systemd-resolved
server=127.0.0.53#12753

# MosDNS
server=127.0.0.1#5553

server=223.5.5.5

EOF

mkdir -p /etc/systemd/resolved.conf.d/
test -e /etc/systemd/resolved.conf.d/01-work-with-dnsmasq.conf || cat << EOF > /etc/systemd/resolved.conf.d/01-work-with-dnsmasq.conf
[Resolve]
DNSStubListener=no
DNSStubListenerExtra=127.0.0.53:12753

EOF

test -e /etc/systemd/resolved.conf.d/90-default-dns.conf || cat << EOF >> /etc/systemd/resolved.conf.d/90-default-dns.conf
# Added by XFL
[Resolve]
DNS=127.0.0.1
FallbackDNS=8.8.8.8
Domains=.
DNSSEC=no
DNSOverTLS=no

EOF

test -e /etc/sysctl.d/50-bbr.conf || cat << EOF >> /etc/sysctl.d/50-bbr.conf
net.core.default_qdisc=fq
net.ipv4.tcp_congestion_control=bbr

EOF

test -e /etc/sysctl.d/50-ipforward.conf || cat << EOF >> /etc/sysctl.d/50-ipforward.conf
net.ipv6.conf.all.forwarding=1
net.ipv4.ip_forward=1

EOF

systemctl daemon-reload
sysctl -p /etc/sysctl.d/50-bbr.conf
sysctl -p /etc/sysctl.d/50-ipforward.conf
apt install -y dnsmasq dnsmasq-utils
systemctl restart systemd-resolved

mkdir -p /mnt/justsave/fs/var/lib/libvirt/images/
mkdir -p /mnt/justsave/fs/var/lib/libvirt/boot/
apt install -y virtinst libvirt-clients virt-viewer virtiofsd qemu-utils qemu-block-extra python3-gi sudo
apt install -y -t noble-backports cockpit cockpit-389-ds cockpit-bridge cockpit-doc cockpit-machines cockpit-networkmanager cockpit-packagekit cockpit-podman cockpit-sosreport cockpit-storaged cockpit-system cockpit-ws 
systemctl reload apparmor.service
systemctl restart apparmor.service



# apt install -y network-manager
# nmcli connection add con-name netplan-dummy0 type dummy ifname dummy0 ipv4.method manual ipv4.addresses 192.168.127.1/32 ipv6.method manual ipv6.addresses fdff:ffff:abcd:fe80:1a:2bff:fe3c:4d5e/128 mtu 9000 ethernet.cloned-mac-address 02:1a:2b:3c:4d:5e
# nmcli connection modify netplan-dummy0 type dummy ifname dummy0 ipv4.method manual ipv4.addresses 192.168.127.1/32 ipv6.method manual ipv6.addresses fdff:ffff:abcd:fe80:1a:2bff:fe3c:4d5e/128 mtu 9000 ethernet.cloned-mac-address 02:1a:2b:3c:4d:5e
# apt install -y libtool build-essential crossbuild-essential-amd64 crossbuild-essential-arm* crossbuild-essential-mips* pkg-config
# apt install -y libssl-dev make libc6-dev libelf-dev libncurses5-dev zlib1g-dev
# apt install -y python3-dateutil python3-pygal python3-bottle* python3-pycrypt* python3-periphery
# apt install -y libgpiod2 libgpiod-dev gpiod
# apt install -y device-tree-compiler
# apt install -y qemu-user-static qemu-block-extra qemu-efi-aarch64 qemu-system qemu-utils

# apt install -y kde-full $(apt list plasma-* 2>/dev/null | grep -v -e dbgsym -e '-dev' | grep '/' | cut -f1 -d'/')
