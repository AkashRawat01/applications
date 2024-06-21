{{/*
Generate a fullname from the release name.
*/}}
{{- define "mydb-chart.fullname" -}}
{{- printf "%s-%s" .Release.Name .Chart.Name | trunc 63 | trimSuffix "-" -}}
{{- end }}

{{/*
Generate a name for the service account.
*/}}
{{- define "mydb-chart.serviceAccountName" -}}
{{- if .Values.serviceAccount.create -}}
{{- default (include "mydb-chart.fullname" .) .Values.serviceAccount.name -}}
{{- else -}}
{{- "default" -}}
{{- end -}}
{{- end }}
