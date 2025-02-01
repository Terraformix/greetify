import prometheus  from 'prom-client'


const register = new prometheus.Registry();

// Custom prometheus metrics

// HTTP Request Count
const httpRequestCount = new prometheus.Counter({
  name: 'http_requests_total',
  help: 'Total number of HTTP requests',
  labelNames: ['method', 'path', 'status'],
  registers: [register]
});

const greetingsCreatedCount = new prometheus.Counter({
    name: "greetings_created_count",
    help: "Total number of greetings created",
    registers: [register]
  })

const greetingsClickedCount = new prometheus.Counter({
  name: "greetings_clicked_count",
  help: "Total number of times a greeting was clicked",
  labelNames: ['id', 'language', 'greeting'],
  registers: [register]
})

register.setDefaultLabels({
  app: "greetify"
})

// Add default metrics (CPU, memory, etc.)
prometheus.collectDefaultMetrics({
  register,
  prefix: 'nodejs_' // Add a prefix to easily find metrics in Prometheus. This is only for default metrics collected by Prometheus regarding NodeJS
});


export {
    register,
    greetingsClickedCount,
    greetingsCreatedCount,
    httpRequestCount
}