


### 创建Ingress方法

```go
package jan

import (
	janv1 "develop-operator/apis/jan/v1"
	appv1 "k8s.io/api/apps/v1"
	corev1 "k8s.io/api/core/v1"
	v1 "k8s.io/api/networking/v1"
	metav1 "k8s.io/apimachinery/pkg/apis/meta/v1"
	"k8s.io/apimachinery/pkg/runtime/schema"
)

func NewJan(app *janv1.Jan) *appv1.Deployment {
	labels := map[string]string{"app": app.Name}
	selector := &metav1.LabelSelector{MatchLabels: labels}
	return &appv1.Deployment{
		TypeMeta: metav1.TypeMeta{
			Kind:       "apps/v1",
			APIVersion: "Deployment",
		},
		ObjectMeta: metav1.ObjectMeta{
			Name:      app.Name,
			Namespace: app.Namespace,
			OwnerReferences: []metav1.OwnerReference{
				*metav1.NewControllerRef(app, schema.GroupVersionKind{
					Group:   janv1.GroupVersion.Group,
					Version: janv1.GroupVersion.Version,
					Kind:    "Jan",
				}),
			},
		},
		Spec: appv1.DeploymentSpec{
			Replicas: app.Spec.Replicas,
			Selector: selector,
			Template: corev1.PodTemplateSpec{
				ObjectMeta: metav1.ObjectMeta{Labels: labels},
				Spec:       corev1.PodSpec{Containers: newContainers(app)},
			},
			MinReadySeconds: 0,
		},
		Status: appv1.DeploymentStatus{},
	}

}

func newContainers(app *janv1.Jan) []corev1.Container {
	containerPorts := []corev1.ContainerPort{}
	for _, svcPort := range app.Spec.Ports {
		cport := corev1.ContainerPort{}
		cport.ContainerPort = svcPort.TargetPort.IntVal
		containerPorts = append(containerPorts, cport)
	}
	return []corev1.Container{
		{
			Name:            app.Name,
			Image:           app.Spec.Image,
			Resources:       app.Spec.Resources,
			Ports:           containerPorts,
			ImagePullPolicy: corev1.PullIfNotPresent,
			Env:             app.Spec.Envs,
		},
	}
}

func NewService(app *janv1.Jan) *corev1.Service {
	return &corev1.Service{
		TypeMeta: metav1.TypeMeta{
			Kind:       "Service",
			APIVersion: "v1",
		},
		ObjectMeta: metav1.ObjectMeta{
			Name:      app.Name,
			Namespace: app.Namespace,
			OwnerReferences: []metav1.OwnerReference{
				*metav1.NewControllerRef(app, schema.GroupVersionKind{
					Group:   janv1.GroupVersion.Group,
					Version: janv1.GroupVersion.Version,
					Kind:    "Jan",
				}),
			},
		},
		Spec: corev1.ServiceSpec{
			Type:  app.Spec.Type,
			Ports: app.Spec.Ports,
			Selector: map[string]string{
				"app": app.Name,
			},
		},
	}
}

const (
	port = 80
)

func NewIngress(app *janv1.Jan) *v1.Ingress {
	pathType := v1.PathTypePrefix
	return &v1.Ingress{
		TypeMeta: metav1.TypeMeta{
			Kind:       "Ingress",
			APIVersion: "v1",
		},
		ObjectMeta: metav1.ObjectMeta{
			Name:      app.Name,
			Namespace: app.Namespace,
		},
		Spec: v1.IngressSpec{
			IngressClassName: nil,
			Rules: []v1.IngressRule{
				{
					Host: app.Spec.Host,
					IngressRuleValue: v1.IngressRuleValue{
						HTTP: &v1.HTTPIngressRuleValue{
							Paths: []v1.HTTPIngressPath{{
								Path:     "/",
								PathType: &pathType,
								Backend: v1.IngressBackend{
									Service: &v1.IngressServiceBackend{
										Name: app.Name,
										Port: v1.ServiceBackendPort{
											Number: int32(port),
										},
									},
									Resource: nil,
								},
							},
							}}},
				},
			},
		},
	}
}
```