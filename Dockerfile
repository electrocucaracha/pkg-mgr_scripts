FROM electrocucaracha/pkg_mgr
MAINTAINER Victor Morales <electrocucaracha@gmail.com>

ENV PKG_DEBUG "false"
ENV PKG_SQL_ENGINE "sqlite"
ENV PKG_DB_USERNAME ""
ENV PKG_DB_PASSWORD ""
ENV PKG_DB_HOSTNAME ""
ENV PKG_DB_DATABASE "pkg_db"
ENV PKG_SCRIPTS_PATH "/var/pkg_mgr/scripts"
ENV PKG_MAIN_FILE "/var/pkg_mgr/install.sh"

COPY scripts /var/pkg_mgr/scripts
COPY install.sh /var/pkg_mgr/install.sh

ENTRYPOINT ["/pkg_mgr"]
CMD ["init"]
