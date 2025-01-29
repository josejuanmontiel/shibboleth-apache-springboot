FROM registry.access.redhat.com/ubi9/ubi-minimal:9.5-1736404155

RUN microdnf -y update \
     && microdnf -y install wget sudo yum rpm-build \
     && microdnf -y clean all

COPY files/install-rpm.sh /tmp
RUN chmod +x /tmp/install-rpm.sh 
RUN /tmp/install-rpm.sh

COPY files/apache-cert.pem \
# files/apache-chain.pem \
/etc/ssl/certs/

COPY files/apache-key.pem \
    /etc/ssl/private/

COPY files/default-ssl.conf \
    /etc/apache2/sites-available/

COPY files/metadata-template.xml \
    files/sp-cert.pem \
    files/sp-key.pem \
    /etc/shibboleth/

COPY files/shibboleth2.xml \
    files/attribute-map.xml \
    /etc/shibboleth/

RUN cd /etc/shibboleth && \
#   chown _shibd sp-*.pem  && \ 
   chmod go= sp-key.pem

# COPY files/shibd-apache2 \
#     /usr/local/sbin/

EXPOSE 80 443

# ENTRYPOINT ["shibd-apache2"]
CMD [ "/sbin/init" ]
