ARG ARCH

FROM quay.io/argoproj/argocd:v2.13.0

ENV ARGOCD_VAULT_PLUGIN_VERSION=1.18.1
ENV SOPS_VERSION=v3.9.1
ENV HELM_SECRETS_VERSION=4.6.2

ADD --chown=argocd:argocd --chmod=700 \
    https://github.com/argoproj-labs/argocd-vault-plugin/releases/download/v${ARGOCD_VAULT_PLUGIN_VERSION}/argocd-vault-plugin_${ARGOCD_VAULT_PLUGIN_VERSION}_linux_${ARCH} \
    /usr/local/bin/argocd-vault-plugin

ADD --chown=argocd:argocd --chmod=700 \
    https://github.com/mozilla/sops/releases/download/${SOPS_VERSION}/sops-${SOPS_VERSION}.linux.${ARCH} \
    /usr/local/bin/sops

# To make it work set env HELM_PLUGINS to "/home/argocd/.local/share/helm/plugins/"
RUN helm plugin install --version ${HELM_SECRETS_VERSION} https://github.com/jkroepke/helm-secrets
