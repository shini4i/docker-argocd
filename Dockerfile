ARG ARGOCD_VERSION=v2.2.4

FROM quay.io/argoproj/argocd:$ARGOCD_VERSION

ENV ARGOCD_VAULT_PLUGIN_VERSION=1.8.0

ADD --chown=argocd:argocd --chmod=700 \
    https://github.com/argoproj-labs/argocd-vault-plugin/releases/download/v${ARGOCD_VAULT_PLUGIN_VERSION}/argocd-vault-plugin_${ARGOCD_VAULT_PLUGIN_VERSION}_linux_amd64 \
    /usr/local/bin/argocd-vault-plugin
