{{/*
    the name of the chart.
*/}}


{{- define "assignment.secretproviderclass" -}}
{{- if .Release.Name }}
{{- printf "%s-spc" .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else if .Values.secretProviderClass.name }}
{{- printf "%s-%s" .Values.project_name .Values.secretProviderClass.name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-spc" .Values.project_name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}


{{- define "assignment.serviceaccount" -}}
{{- if .Release.Name }}
{{- printf "%s-sa" .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else if .Values.serviceAccount.name }}
{{- printf "%s-%s" .Values.project_name .Values.serviceAccount.name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-sa" .Values.project_name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}



{{- define "assignment.deployment" -}}
{{- if .Release.Name }}
{{- printf "%s-deploy" .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else if .Values.deployment.name }}
{{- printf "%s-%s" .Values.project_name .Values.deployment.name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-deploy" .Values.project_name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}



