cat <<-EOF > /etc/yum.repos.d/shibboleth.repo
[shibboleth]
name=Shibboleth (CentOS_8)
# Please report any problems to https://shibboleth.atlassian.net/jira
type=rpm-md
mirrorlist=https://shibboleth.net/cgi-bin/mirrorlist.cgi/CentOS_8
gpgcheck=1
gpgkey=https://shibboleth.net/downloads/service-provider/RPMS/repomd.xml.key
        https://shibboleth.net/downloads/service-provider/RPMS/cantor.repomd.xml.key
enabled=1
EOF

# Import Shibboleth's GPG keys
rpm --import https://shibboleth.net/downloads/service-provider/RPMS/repomd.xml.key
rpm --import https://shibboleth.net/downloads/service-provider/RPMS/cantor.repomd.xml.key

# https://shibboleth-mirror.cdi.ti.ja.net/CentOS_8/x86_64/shibboleth-3.0.4-1.x86_64.rpm

# https://shibboleth-mirror.cdi.ti.ja.net/rockylinux9/x86_64/shibboleth-3.5.0-2.el9.x86_64.rpm
# https://shibboleth-mirror.cdi.ti.ja.net/rockylinux9/src/shibboleth-3.5.0-2.el9.src.rpm

yum -y install httpd shibboleth-3.0.4-1