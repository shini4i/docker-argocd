ARG ARGOCD_VERSION=v2.2.2

FROM curlimages/curl as downloader
ENV ARGOCD_VAULT_PLUGIN_VERSION=1.6.0

RUN curl -L https://github.com/argoproj-labs/argocd-vault-plugin/releases/download/v$ARGOCD_VAULT_PLUGIN_VERSION/argocd-vault-plugin_$ARGOCD_VAULT_PLUGIN_VERSION\_linux_amd64 --output /tmp/argocd-vault-plugin \
 && chmod +x /tmp/argocd-vault-plugin

FROM quay.io/argoproj/argocd:$ARGOCD_VERSION

COPY --from=downloader /tmp/argocd-vault-plugin /usr/local/bin/argocd-vault-plugin
