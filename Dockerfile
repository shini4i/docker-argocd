FROM quay.io/argoproj/argocd:v2.9.3

ENV ARGOCD_VAULT_PLUGIN_VERSION=1.17.0
ENV SOPS_VERSION=v3.8.1
ENV HELM_SECRETS_VERSION=4.5.1

ADD --chown=argocd:argocd --chmod=700 \
    https://github.com/argoproj-labs/argocd-vault-plugin/releases/download/v${ARGOCD_VAULT_PLUGIN_VERSION}/argocd-vault-plugin_${ARGOCD_VAULT_PLUGIN_VERSION}_linux_amd64 \
    /usr/local/bin/argocd-vault-plugin

ADD --chown=argocd:argocd --chmod=700 \
    https://github.com/mozilla/sops/releases/download/${SOPS_VERSION}/sops-${SOPS_VERSION}.linux.amd64 \
    /usr/local/bin/sops

# To make it work set env HELM_PLUGINS to "/home/argocd/.local/share/helm/plugins/"
RUN helm plugin install --version ${HELM_SECRETS_VERSION} https://github.com/jkroepke/helm-secrets
