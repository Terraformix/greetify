import dotenv from 'dotenv';
import express from 'express';
import cors from 'cors';
import { getAllGreetings, getGreeting, createGreeting, deleteGreeting } from './controllers/greetingsController.js';
import { initializeConnection, initializeDb, poolPromise, seedDatabase } from './database/db.js';
import { httpRequestCount, register } from './custom-metrics/metrics.js';
import { serviceConfig } from './config.js';

dotenv.config();

const app = express();
const PORT = process.env.PORT || 8080;

app.use(cors());
app.use(express.json());

app.use((req, res, next) => {

  // Middleware to add version to every response
  res.setHeader("X-App-Version", serviceConfig.appVersion);

  res.on('finish', () => {
    // Pass in parameters to the custom metric to track most visited path
    httpRequestCount.labels(req.method, req.path, res.statusCode).inc();    
  });

  next();
});


app.get('/api/greetings/:id', getGreeting);
app.get('/api/greetings', getAllGreetings);
app.post('/api/greetings', createGreeting);
app.delete('/api/greetings/:id', deleteGreeting);



// Metrics endpoint used by Prometheus to query for metrics from the application in a format that prometheus expects
// This is required to be able to get application-level and custom metrics
app.get('/metrics', async (req, res) => {
  res.setHeader('Content-Type', register.contentType);
  res.send(await register.metrics());
});

// Healthcheck endpoint used by Kubernetes Health Probes to determine when the server is ready to stary handling requests from the DB
app.get('/health', async (req, res) => {
  try {
    
    await initializeConnection();

    res.status(200).send({
      status: "Server is ready to accept connections :)"
    });
  } catch (err) {
    res.status(500).send({
      status: "Server is not ready to accept connections :("
    });
  }
});

async function startServer() {

  try {

    if(process.env.USE_DB !== 'false') {
      await initializeDb();
      //await seedDatabase();
    }

    app.listen(PORT, () => {
      console.log(`Server is running on port http://localhost:${PORT}`);
    });
  } catch (err) {
    console.error('Failed to start server:', err);
    process.exit(1);
  }
}

startServer();