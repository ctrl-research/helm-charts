{{/*
Resource name: <release>-<key>, truncated to the 63 char limit.
Call with (dict "root" $ "name" $name).
*/}}
{{- define "generic.fullname" -}}
{{- printf "%s-%s" .root.Release.Name .name | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Render a user-supplied Kubernetes manifest verbatim.

The chart supplies apiVersion and kind and sets metadata.name to the
chart-prefixed name; every other field is passed through untouched. Any
apiVersion, kind, or metadata.name in the supplied manifest is ignored.
Top-level .Values.metadata is deep-merged first and can be overridden
per-resource by the manifest's own metadata block.

Call with (dict "root" $ "name" $name "apiVersion" $v "kind" $k "config" $config).
*/}}
{{- define "generic.manifest" -}}
{{- $config := .config | default dict -}}
{{- $obj := merge (omit $config "apiVersion" "kind") (dict "apiVersion" .apiVersion "kind" .kind) -}}
{{- $metadata := mergeOverwrite (deepCopy (.root.Values.metadata | default dict)) (deepCopy ($config.metadata | default dict)) (dict "name" (include "generic.fullname" (dict "root" .root "name" .name))) -}}
{{- $_ := set $obj "metadata" $metadata -}}
{{ toYaml $obj }}
{{- end -}}