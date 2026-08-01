{{/*
Resource name: <release>-<key>, truncated to the 63 char limit.
Call with (dict "root" $ "name" $name).
*/}}
{{- define "generic.fullname" -}}
{{- printf "%s-%s" .root.Release.Name .name | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Selector labels. Used in Deployment matchLabels and Service selectors.
Deployment selectors are immutable — never add labels here.
*/}}
{{- define "generic.selectorLabels" -}}
app.kubernetes.io/name: {{ include "generic.fullname" . }}
{{- end -}}

{{/*
Metadata labels. Safe to extend.
*/}}
{{- define "generic.labels" -}}
{{ include "generic.selectorLabels" . }}
app.kubernetes.io/instance: {{ .root.Release.Name }}
app.kubernetes.io/managed-by: {{ .root.Release.Service }}
helm.sh/chart: {{ printf "%s-%s" .root.Chart.Name .root.Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end -}}
