# Application configuration example
## General information
The following examples might look a bit odd, but currently, it's not possible to use values substitution in Application CRD without a "proxy" chart. Hence, for now, we are using a "proxy" helm chart to deploy Applications requiring plain text credentials to be passed to the resulting helm chart.
## Minimal configuration
application.yaml
```yaml
apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: vault-enabled-setup
  namespace: argo-cd
  finalizers:
    - resources-finalizer.argocd.argoproj.io
spec:
  project: default
  source:
    repoURL: "ssh://git@github.com/example/gitops.git"
    targetRevision: "main"
    path: "test/.charts/vault-enabled-setup"
    plugin:
      name: argocd-vault-plugin-helm
      env:
        - name: helm_args
          value: --namespace=$ARGOCD_APP_NAMESPACE

  destination:
    server: https://kubernetes.default.svc
    namespace: argo-cd

  syncPolicy:
    automated:
      prune: true
      selfHeal: true
    syncOptions:
      - CreateNamespace=true
```
Content of test/.charts/vault-enabled-setup path:
```
- test/.charts/vault-enabled-setup --
                                    |- Chart.yaml
                                    |- templates --
                                                  |- app.yaml
                                                  |- secret.yaml
```
app.yaml
```yaml
apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: example-app
  namespace: argo-cd
  finalizers:
    - resources-finalizer.argocd.argoproj.io
spec:
  project: default
  source:
    repoURL: https://charts.example.com
    chart: test
    targetRevision: "0.1.0"
    helm:
      values: |
        secret_variable: "<path:argocd/data/super-secret#PASSWORD>"

  destination:
    server: https://kubernetes.default.svc
    namespace: example

  syncPolicy:
    automated:
      selfHeal: true
    syncOptions:
      - CreateNamespace=true
```
secret.yaml
```yaml
apiVersion: v1
kind: Secret
metadata:
  name: example-secret
  namespace: example
type: Opaque
stringData:
  test: "<path:argocd/data/super-secret#TEST>"
```
