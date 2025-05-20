FROM quay.io/argoproj/argocd:v3.0.2

ARG TARGETARCH

ENV ARGOCD_VAULT_PLUGIN_VERSION=1.18.1
ENV SOPS_VERSION=v3.10.2
ENV HELM_SECRETS_VERSION=4.6.3

ADD --chown=argocd:argocd --chmod=700 \
    https://github.com/argoproj-labs/argocd-vault-plugin/releases/download/v${ARGOCD_VAULT_PLUGIN_VERSION}/argocd-vault-plugin_${ARGOCD_VAULT_PLUGIN_VERSION}_linux_${TARGETARCH} \
    /usr/local/bin/argocd-vault-plugin

ADD --chown=argocd:argocd --chmod=700 \
    https://github.com/mozilla/sops/releases/download/${SOPS_VERSION}/sops-${SOPS_VERSION}.linux.${TARGETARCH} \
    /usr/local/bin/sops

# To make it work set env HELM_PLUGINS to "/home/argocd/.local/share/helm/plugins/"
RUN helm plugin install --version ${HELM_SECRETS_VERSION} https://github.com/jkroepke/helm-secrets
