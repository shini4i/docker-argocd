# Application configuration example
## Minimal configuration
application.yaml
```yaml

apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: sops-test
  namespace: argo-cd
  finalizers:
    - resources-finalizer.argocd.argoproj.io
spec:
  project: default
  source:
    repoURL: "ssh://git@github.com/example/gitops.git"
    targetRevision: "main"
    path: "test/.charts/sops-test"
    helm:
      valueFiles:
        - "secrets+age-import:///opt/secrets/key.txt?values.yaml"

  destination:
    server: https://kubernetes.default.svc
    namespace: sandbox

  syncPolicy:
    automated:
      prune: true
      selfHeal: true
    syncOptions:
      - CreateNamespace=true
```
Content of test/.charts/sops-test path:
```
- test/.charts/sops-test --
                          |- Chart.yaml
                          |- values.yaml
```
To sops encrypt values.yaml file:
```bash
sops --encrypt --age ID -i values.yaml
```
That's it, no more configuration is required. The encrypted values file would be decrypted on ArgoCD side automatically.