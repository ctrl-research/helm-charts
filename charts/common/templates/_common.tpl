{{- /*
common.metadata.name will provide a re-usable standardized name.
*/}}
{{- define "common.metadata.name" -}}
{{ .Chart.Name }}
{{- end -}}

{{- /*
common.metadata.labels will provide a re-usable standardized set of labels.
*/}}
{{- define "common.metadata.labels" -}}
{{- if .Values.metadata }}
{{ toYaml .Values.metadata }}
{{- end }}
{{ include "common.metadata.selectorLabels" . }}
{{- end -}}

{{- /*
common.metadata.selectorLabels will provide a re-usable standardized set of selectorLabels.
*/}}
{{- define "common.metadata.selectorLabels" -}}
app.kubernetes.io/name: {{ include "common.metadata.name" . }}
{{- end -}}
