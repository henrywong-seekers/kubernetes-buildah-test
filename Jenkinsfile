podTemplate(yaml: """
apiVersion: v1
kind: Pod
spec:
  serviceAccountName: ecr
  containers:
  - name: buildah
    image: quay.io/buildah/stable:v1.14.3
    env:
    - name: STORAGE_DRIVER
      value: vfs
    command: ["cat"]
    tty: true
"""
) {
  node(POD_LABEL) {
    checkout scm

    stage('Build') {
      container('buildah') {
        sh './vfs.sh'
        sh 'buildah unshare ./test.sh'
      }
    }
  }
}
