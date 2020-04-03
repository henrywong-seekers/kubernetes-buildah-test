podTemplate(yaml: """
apiVersion: v1
kind: Pod
spec:
  serviceAccountName: ecr
  containers:
  - name: buildah
    image: quay.io/buildah/stable:v1.14.3
    command: ["cat"]
    tty: true
    volumeMounts:
    - name: containers1
      mountPath: /var/lib/containers
    - name: fuse
      mountPath: /dev/fuse
  volumes:
  - name: containers1
    hostPath:
      path: /var/lib/containers1
  - name: fuse
    hostPath:
      path: /dev/fuse
"""
) {
  node(POD_LABEL) {
    checkout scm

    stage('Build') {
      container('buildah') {
        sh 'buildah unshare ./test.sh'
      }
    }
  }
}
