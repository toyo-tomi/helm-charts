{{- define "templating-deep-dive.v1.fullname" }}
{{- $fullName := printf "%s-%s" .Release.Name .Chart.Name }}
{{- .Values.customName | default $fullName | trunc 63 | trim -}}
{{- end }}

{{- define "templating-deep-dive.v1.selectorLabels" -}}
app: {{ .Chart.Name }}
release: {{ .Release.Name }}
managedBy: "helm"
{{- end -}}

{{/* Expects a port to be passed as the context */}}
{{- define "templating-deep-dive.v1.validators.portRange" -}}
{{- $sanitizedPort := int . }}
{{- if or (lt $sanitizedPort 1) (gt $sanitizedPort 65535) }}
{{- fail "Error: Ports must always be between 1 and 65535." }}
{{- end -}}
{{- $sanitizedPort }}
{{- end -}}

{{/* Expects an integer or string to be passed as the context */}}
{{- define "templating-deep-dive.v2.validators.portRange" -}}
{{- $sanitizedPort := int . }}
{{/* Service port validation */}}
{{- if or (lt $sanitizedPort 1) (gt $sanitizedPort 65535) }}
{{- fail "Error: Ports must always be between 1 and 65535." }}
{{- end -}}
{{- end -}}

{{/* Expects an object with port and type to be passed as the context */}}
{{- define "templating-deep-dive.v1.validators.service" -}}
{{- include "templating-deep-dive.v2.validators.portRange" .port }}

{{/* Service type validation */}}
{{- $allowedSvcTypes := list "ClusterIP" "NodePort" }}
{{- if not (has .type $allowedSvcTypes) }}
{{- fail (printf "Invalid service type %s. Supported values are: %s" .type (join ", " $allowedSvcTypes)) }}
{{- end -}}
{{- end -}}
