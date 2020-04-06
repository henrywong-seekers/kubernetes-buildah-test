#!/bin/sh

dnf install -q unzip -y || {
  echo "Failed to install unzip"
  exit 1
}

echo "Installed unzip"

curl -sS https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip -o awscliv2.zip || {
  echo "Failed to download awscli"
  exit 1
}

echo "Downloaded awscli"

curl -sS https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip.sig -o awscliv2.sig || {
  echo "Failed to download awscli signature"
  exit 1
}

echo "Downloaded awscli signature"

cat << EOF | gpg --import - 2>/dev/null
-----BEGIN PGP PUBLIC KEY BLOCK-----

mQINBF2Cr7UBEADJZHcgusOJl7ENSyumXh85z0TRV0xJorM2B/JL0kHOyigQluUG
ZMLhENaG0bYatdrKP+3H91lvK050pXwnO/R7fB/FSTouki4ciIx5OuLlnJZIxSzx
PqGl0mkxImLNbGWoi6Lto0LYxqHN2iQtzlwTVmq9733zd3XfcXrZ3+LblHAgEt5G
TfNxEKJ8soPLyWmwDH6HWCnjZ/aIQRBTIQ05uVeEoYxSh6wOai7ss/KveoSNBbYz
gbdzoqI2Y8cgH2nbfgp3DSasaLZEdCSsIsK1u05CinE7k2qZ7KgKAUIcT/cR/grk
C6VwsnDU0OUCideXcQ8WeHutqvgZH1JgKDbznoIzeQHJD238GEu+eKhRHcz8/jeG
94zkcgJOz3KbZGYMiTh277Fvj9zzvZsbMBCedV1BTg3TqgvdX4bdkhf5cH+7NtWO
lrFj6UwAsGukBTAOxC0l/dnSmZhJ7Z1KmEWilro/gOrjtOxqRQutlIqG22TaqoPG
fYVN+en3Zwbt97kcgZDwqbuykNt64oZWc4XKCa3mprEGC3IbJTBFqglXmZ7l9ywG
EEUJYOlb2XrSuPWml39beWdKM8kzr1OjnlOm6+lpTRCBfo0wa9F8YZRhHPAkwKkX
XDeOGpWRj4ohOx0d2GWkyV5xyN14p2tQOCdOODmz80yUTgRpPVQUtOEhXQARAQAB
tCFBV1MgQ0xJIFRlYW0gPGF3cy1jbGlAYW1hem9uLmNvbT6JAlQEEwEIAD4WIQT7
Xbd/1cEYuAURraimMQrMRnJHXAUCXYKvtQIbAwUJB4TOAAULCQgHAgYVCgkICwIE
FgIDAQIeAQIXgAAKCRCmMQrMRnJHXJIXEAChLUIkg80uPUkGjE3jejvQSA1aWuAM
yzy6fdpdlRUz6M6nmsUhOExjVIvibEJpzK5mhuSZ4lb0vJ2ZUPgCv4zs2nBd7BGJ
MxKiWgBReGvTdqZ0SzyYH4PYCJSE732x/Fw9hfnh1dMTXNcrQXzwOmmFNNegG0Ox
au+VnpcR5Kz3smiTrIwZbRudo1ijhCYPQ7t5CMp9kjC6bObvy1hSIg2xNbMAN/Do
ikebAl36uA6Y/Uczjj3GxZW4ZWeFirMidKbtqvUz2y0UFszobjiBSqZZHCreC34B
hw9bFNpuWC/0SrXgohdsc6vK50pDGdV5kM2qo9tMQ/izsAwTh/d/GzZv8H4lV9eO
tEis+EpR497PaxKKh9tJf0N6Q1YLRHof5xePZtOIlS3gfvsH5hXA3HJ9yIxb8T0H
QYmVr3aIUes20i6meI3fuV36VFupwfrTKaL7VXnsrK2fq5cRvyJLNzXucg0WAjPF
RrAGLzY7nP1xeg1a0aeP+pdsqjqlPJom8OCWc1+6DWbg0jsC74WoesAqgBItODMB
rsal1y/q+bPzpsnWjzHV8+1/EtZmSc8ZUGSJOPkfC7hObnfkl18h+1QtKTjZme4d
H17gsBJr+opwJw/Zio2LMjQBOqlm3K1A4zFTh7wBC7He6KPQea1p2XAMgtvATtNe
YLZATHZKTJyiqA==
=vYOk
-----END PGP PUBLIC KEY BLOCK-----
EOF

gpg --verify awscliv2.sig awscliv2.zip 2>/dev/null || {
  echo "Failed to verify awscli"
  exit 1
}

echo "Verified awscli"

unzip -q awscliv2.zip || {
  echo "Failed to unzip awscli"
  exit 1
}

echo "Unziped awscli"

curl -LOfsS https://github.com/stedolan/jq/releases/download/jq-1.6/jq-linux64 || {
  echo "Failed to download jq"
  exit 1
}

echo "Downloaded jq"

curl -OfsS https://raw.githubusercontent.com/stedolan/jq/master/sig/v1.6/jq-linux64.asc || {
  echo "Failed to download jq signature"
  exit 1
}

echo "Downloaded jq signature"

curl -OfsS https://raw.githubusercontent.com/stedolan/jq/master/sig/v1.6/sha256sum.txt || {
  echo "Failed to download jq checksum"
  exit 1
}

echo "Downloaded jq checksum"

curl -sS https://raw.githubusercontent.com/stedolan/jq/master/sig/jq-release.key | gpg --import 2>/dev/null || {
  echo "Failed import jq gpg key"
  exit 1
}

echo "Imported jq gpg key"

gpg --verify jq-linux64.asc 2>/dev/null || {
  echo "Failed to verify jq"
  exit 1
}

echo "Verified jq"

sha256sum -c --ignore-missing --quiet sha256sum.txt || {
  echo "Failed to verify jq checksum"
  exit 1
}

echo "Verified jq checksum"

chmod +x jq-linux64

ctr0=$(buildah from fedora:31)
mnt0=$(buildah mount $ctr0)

buildah copy $ctr0 aws aws
buildah run $ctr0 aws/install

ctr=$(buildah from fedora:31)
mnt=$(buildah mount $ctr)

cp $mnt0/usr/local/bin/aws $mnt/usr/local/bin
cp $mnt0/usr/local/bin/aws_completer $mnt/usr/local/bin

cp -r $mnt0/usr/local/aws-cli $mnt/usr/local

cp jq-linux64 $mnt/usr/local/bin/jq

buildah unmount $ctr0
buildah unmount $ctr

buildah config --entrypoint "" $ctr
buildah config --cmd "/bin/bash" $ctr

buildah commit $ctr test
