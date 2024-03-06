{{/*
Expand the name of the chart.
*/}}
{{- define "capacity-reservation.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "capacity-reservation.fullname" -}}
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
Create a default API prefix for ingress and networking purposes
*/}}
{{- define "capacity-reservation.apiPrefix" -}}
{{- if .Values.ingress.apiPrefix }}
{{- .Values.ingress.apiPrefix }}
{{- else }}
{{- (include "capacity-reservation.fullname" .) | replace "-" "_" }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "capacity-reservation.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "capacity-reservation.labels" -}}
helm.sh/chart: {{ include "capacity-reservation.chart" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- if .Values.commonLabels }}
{{ toYaml .Values.commonLabels }}
{{- end }}
{{- end }}

{{/*
Reservation selector labels
*/}}
{{- define "capacity-reservation.reservation.selectorLabels" -}}
app.kubernetes.io/name: {{ include "capacity-reservation.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/component: reservation
{{- end }}

{{/*
Reservation labels
*/}}
{{- define "capacity-reservation.reservation.labels" -}}
{{ include "capacity-reservation.labels" . }}
{{ include "capacity-reservation.reservation.selectorLabels" . }}
{{- end }}

{{/*
Schedule selector labels
*/}}
{{- define "capacity-reservation.schedule.selectorLabels" -}}
app.kubernetes.io/name: {{ include "capacity-reservation.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/component: schedule
{{- end }}

{{/*
Schedule labels
*/}}
{{- define "capacity-reservation.schedule.labels" -}}
{{ include "capacity-reservation.labels" . }}
{{ include "capacity-reservation.schedule.selectorLabels" . }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "capacity-reservation.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "capacity-reservation.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

