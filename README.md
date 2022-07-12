# vpnpritunl

- image: OL8.5-x86_64-HVM-2021-11-24
- https://docs.pritunl.com/docs/installation

```
sudo tee /etc/yum.repos.d/mongodb-org-5.0.repo << EOF
[mongodb-org-5.0]
name=MongoDB Repository
baseurl=https://repo.mongodb.org/yum/redhat/8/mongodb-org/5.0/x86_64/
gpgcheck=1
enabled=1
gpgkey=https://www.mongodb.org/static/pgp/server-5.0.asc
EOF

sudo tee /etc/yum.repos.d/pritunl.repo << EOF
[pritunl]
name=Pritunl Repository
baseurl=https://repo.pritunl.com/stable/yum/oraclelinux/8/
gpgcheck=1
enabled=1
EOF

sudo yum -y install oracle-epel-release-el8
sudo yum-config-manager --enable ol8_developer_EPEL
sudo yum -y update

# WireGuard server support
sudo yum -y install wireguard-tools

sudo yum -y remove iptables-services
sudo systemctl stop firewalld.service
sudo systemctl disable firewalld.service

# Import signing key from keyserver
gpg --keyserver hkp://keyserver.ubuntu.com --recv-keys 7568D9BB55FF9E5287D586017AE645C0CF8E292A
gpg --armor --export 7568D9BB55FF9E5287D586017AE645C0CF8E292A > key.tmp; sudo rpm --import key.tmp; rm -f key.tmp
# Alternative import from download if keyserver offline
sudo rpm --import https://raw.githubusercontent.com/pritunl/pgp/master/pritunl_repo_pub.asc

sudo yum -y install pritunl mongodb-org
sudo systemctl enable mongod pritunl
sudo systemctl start mongod pritunl
```
---
```
sudo pritunl setup-key
sudo pritunl default-password
sudo systemctl restart pritunl

```
---
```
sudo dnf -y update
sudo dnf -y install dnf-automatic
sudo sed -i 's/^upgrade_type =.*/upgrade_type = default/g' /etc/dnf/automatic.conf
sudo sed -i 's/^download_updates =.*/download_updates = yes/g' /etc/dnf/automatic.conf
sudo sed -i 's/^apply_updates =.*/apply_updates = yes/g' /etc/dnf/automatic.conf
sudo systemctl enable --now dnf-automatic.timer

sudo systemctl restart pritunl
```


```
sudo tee -a /etc/yum.repos.d/pritunl.repo << EOF
[pritunl]
name=Pritunl 
baseurl=https://repo.pritunl.com/stable/yum/amazonlinux/2/
gpgcheck=1
enabled=1
EOF

sudo rpm -Uvh https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
gpg --keyserver hkp://keyserver.ubuntu.com --recv-keys 7568D9BB55FF9E5287D586017AE645C0CF8E292A
gpg --armor --export 7568D9BB55FF9E5287D586017AE645C0CF8E292A > key.tmp; sudo rpm --import key.tmp; rm -f key.tmp
sudo yum -y install pritunl-link

sudo pritunl-link verify-off
sudo pritunl-link provider aws
sudo pritunl-link add pritunl://token:secret@test.pritunl.com
```
 ---
 - https://docs.pritunl.com/docs/aws
 - https://docs.pritunl.com/docs/pritunl-link
 - https://docs.pritunl.com/docs/internal-dns
