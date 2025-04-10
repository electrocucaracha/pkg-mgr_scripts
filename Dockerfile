#checkov:skip=CKV_DOCKER_2

FROM electrocucaracha/pkg_mgr:v0.0.1 as bin

FROM scratch

ENV PKG_DEBUG "false"
ENV PKG_SQL_ENGINE "sqlite"
ENV PKG_DB_USERNAME ""
ENV PKG_DB_PASSWORD ""
ENV PKG_DB_HOSTNAME ""
ENV PKG_DB_DATABASE "pkg_db"
ENV PKG_SCRIPTS_PATH "/var/pkg_mgr/scripts"
ENV PKG_MAIN_FILE "/var/pkg_mgr/install.sh"

COPY src /var/pkg_mgr/scripts
COPY install.sh /var/pkg_mgr/install.sh
COPY --from=bin /pkg_mgr /opt/pkg_mgr

USER 10001:10001

ENTRYPOINT ["/opt/pkg_mgr"]
CMD ["init"]
