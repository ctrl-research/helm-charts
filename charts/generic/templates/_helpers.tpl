{{- define "generic.labels" -}}
app.kubernetes.io/name: {{ .releaseName }}-{{ .name }}
{{- end -}}
