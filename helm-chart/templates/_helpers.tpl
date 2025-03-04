{{- define "app.apiVersion" -}}
apps/v1
{{- end }}

{{- define "app.labels" -}}
app: {{ .Values.deployment.app }}
release: {{ .Release.Name }}
{{- end }}

{{- define "app.selectorLabels" -}}
app: {{ .Values.deployment.app }}
{{- end }}

{{- define "app.readinessProbe" -}}
readinessProbe:
  httpGet:
    path: {{ .Values.probes.readiness.path }}
    port: {{ .Values.deployment.port }}
  initialDelaySeconds: {{ .Values.probes.readiness.initialDelaySeconds }}
  periodSeconds: {{ .Values.probes.readiness.periodSeconds }}
{{- end }}

{{- define "app.livenessProbe" -}}
livenessProbe:
  httpGet:
    path: {{ .Values.probes.liveness.path }}
    port: {{ .Values.deployment.port }}
  initialDelaySeconds: {{ .Values.probes.liveness.initialDelaySeconds }}
  periodSeconds: {{ .Values.probes.liveness.periodSeconds }}
{{- end }}

{{- define "app.deployment" -}}
apiVersion: apps/v1
kind: Deployment
metadata:
  name: {{ .Values.deployment.name }}
  labels:
    {{- include "app.labels" . | nindent 4 }}
spec:
  replicas: {{ .Values.deployment.replicas }}
  selector:
    matchLabels:
      {{- include "app.selectorLabels" . | nindent 6 }}
  strategy:
    type: RollingUpdate
    rollingUpdate:
      maxUnavailable: {{ .Values.rollingUpdate.maxUnavailable }}
      maxSurge: {{ .Values.rollingUpdate.maxSurge }}
  template:
    metadata:
      labels:
        {{- include "app.selectorLabels" . | nindent 8 }}
    spec:
      containers:
        - name: {{ .Values.deployment.containerName }}
          image: "{{ .Values.deployment.image.repository }}:{{ .Values.deployment.image.tag }}"
          imagePullPolicy: {{ .Values.deployment.image.pullPolicy }}
          ports:
            - containerPort: {{ .Values.deployment.port }}
          env:
            - name: NODE_ENV
              value: "{{ .Values.env.NODE_ENV }}"
            - name: MONGO_URI
              value: "{{ .Values.env.MONGO_URI }}"
          
{{- end }}

{{- define "app.service" -}}
apiVersion: v1
kind: Service
metadata:
  name: {{ .Values.service.name }}
spec:
  selector:
    {{- include "app.selectorLabels" . | nindent 4 }}
  ports:
    - protocol: TCP
      port: {{ .Values.service.port }}
      targetPort: {{ .Values.service.port }}
      nodePort: {{ .Values.service.nodePort }}
  type: {{ .Values.service.type }}
{{- end }}

{{- define "app.mongodb.deployment" -}}
apiVersion: apps/v1
kind: Deployment
metadata:
  name: {{ .Values.mongoDeployment.name }}
  labels:
    {{- include "app.labels" . | nindent 4 }}
spec:
  replicas: {{ .Values.mongoDeployment.replicas }}
  selector:
    matchLabels:
      app: {{ .Values.mongoDeployment.app }}
  template:
    metadata:
      labels:
        app: {{ .Values.mongoDeployment.app }}
    spec:
      containers:
        - name: {{ .Values.mongoDeployment.containerName }}
          image: "{{ .Values.mongoDeployment.image.repository }}:{{ .Values.mongoDeployment.image.tag }}"
          imagePullPolicy: {{ .Values.mongoDeployment.image.pullPolicy }}
          ports:
            - containerPort: {{ .Values.mongoDeployment.port }}
{{- end }}

{{- define "app.mongodb.service" -}}
apiVersion: v1
kind: Service
metadata:
  name: {{ .Values.mongoService.name }}
spec:
  selector:
    app: {{ .Values.mongoDeployment.app }}
  ports:
    - protocol: TCP
      port: {{ .Values.mongoService.port }}
      targetPort: {{ .Values.mongoService.port }}
  type: {{ .Values.mongoService.type }}
{{- end }}
