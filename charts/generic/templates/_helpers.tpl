{{- define "generic.labels" -}}
app.kubernetes.io/name: {{ .chartName }}-{{ .name }}
{{- end -}}
