# ArgoCD configuration

## Minimal configuration
If ArgoCD is installed using the official helm chart the following configuration should be sufficient to make it work:
```yaml
server:
  config:
    configManagementPlugins: |
    - name: argocd-vault-plugin-helm
      init:
        command: ["sh", "-c"]
        args: ["helm dependency build"]
      generate:
        command: ["sh", "-c"]
        args: ["helm template $ARGOCD_APP_NAME ${helm_args} . | argocd-vault-plugin --config-path /opt/secrets/config.yaml generate -"]

repoServer:
  image:
    repository: ghcr.io/shini4i/argocd
    tag: v2.3.0
    imagePullPolicy: IfNotPresent

  volumes:
    - name: vault-config
      secret:
        secretName: vault-config
        items:
          - key: config.yaml
            path: config.yaml

  volumeMounts:
    - mountPath: "/opt/secrets/"
      name: vault-config
      readOnly: true
```

vault-config secret content:
```
config.yaml: VAULT_ADDR: https://vault.example.com
AVP_AUTH_TYPE: approle
AVP_TYPE: vault
AVP_ROLE_ID: role_id
AVP_SECRET_ID: secret_id
AVP_KV_VERSION: 2
```
## Password protected helm chart repository
To make the setup work in case of password protected helm charts repositories the following changes are required:
```yaml
server:
  config:
    configManagementPlugins: |
    - name: argocd-vault-plugin-helm
      init:
        command: ["sh", "-c"]
        args: ["helm repo add example https://charts.example.com --username $CHARTS_LOGIN --password $CHARTS_PASSWORD && helm dependency build"]
      generate:
        command: ["sh", "-c"]
        args: ["helm template $ARGOCD_APP_NAME ${helm_args} . | argocd-vault-plugin --config-path /opt/secrets/config.yaml generate -"]

repoServer:
  image:
    repository: ghcr.io/shini4i/argocd
    tag: v2.3.0
    imagePullPolicy: IfNotPresent

  volumes:
    - name: vault-config
      secret:
        secretName: vault-config
        items:
          - key: config.yaml
            path: config.yaml

  volumeMounts:
    - mountPath: "/opt/secrets/"
      name: vault-config
      readOnly: true

  envFrom:
    - secretRef:
        name: chartmuseum-creds
```
