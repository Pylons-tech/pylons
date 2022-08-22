{{- define "ports.service" }}
{{- range $key, $value := .Values.ports }}
- port: {{ $v := $value | toString | splitList ":" }}{{$v | first}}
  name: {{ $key }}
  targetPort: {{ $v := $value | toString | splitList ":" }}{{$v | last}}
{{- end }}
{{- end }}

{{- define "ports.pod" }}
{{- range $key, $value := .Values.ports }}
  - containerPort: {{ $v := $value | toString | splitList ":" }}{{$v | last}}
    name: {{ $key }}
{{- end }}
{{- end }}

{{- define "chart.labels" }}
app.kubernetes.io/name: {{ .Chart.Name }}
helm.sh/chart: {{ .Chart.Name }}-{{ .Chart.Version | replace "+" "_" }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/version: {{ .Chart.AppVersion }}
{{- if .Values.labels }}{{ toYaml .Values.labels}}{{- end }}
{{- end }}

{{/*
Expand the name of the chart.
*/}}
{{- define "big-dipper-v1.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "big-dipper-v1.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "big-dipper-v1.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "big-dipper-v1.labels" -}}
helm.sh/chart: {{ include "big-dipper-v1.chart" . }}
{{ include "big-dipper-v1.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "big-dipper-v1.selectorLabels" -}}
app.kubernetes.io/name: {{ include "big-dipper-v1.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "big-dipper-v1.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "big-dipper-v1.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}
