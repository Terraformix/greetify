import sql from 'mssql';
import dotenv from 'dotenv';

dotenv.config();

const getConfig = (dbName = 'master') => ({
  user: process.env.DB_USER || 'sa',
  password: process.env.DB_PASSWORD || 'password',
  server: process.env.DB_HOST || 'localhost',
  database: dbName,
  options: {
    trustServerCertificate: true,
    enableArithAbort: true,  // Add this
    encrypt: process.env.IS_AZURE_DB === 'true'
  },
  port: parseInt(process.env.DB_PORT, 10) || 1433,
});

const isAzureDb = process.env.IS_AZURE_DB === 'true';

console.log("Is Azure DB? ", isAzureDb)

let pool = null;
let poolPromise = null;

const initializeConnection = async () => {
  if (!pool) {
    const maxRetries = 10;
    const retryInterval = 6000;
    
    for (let i = 0; i < maxRetries; i++) {
      console.log("Initializing Connection.. Attempt: ", i + 1)
      try {
        pool = new sql.ConnectionPool(getConfig());
        poolPromise = await pool.connect();
        console.log('Connected to MSSQL master database');
        return poolPromise;
      } catch (err) {
        console.log(`Connection attempt ${i + 1} failed: ${err}`);
        if (i < maxRetries - 1) {
          await new Promise(resolve => setTimeout(resolve, retryInterval));
        }
      }
    }
    throw new Error('Failed to connect after max retries');
  }
  return poolPromise;
};

async function initializeDb() {
  try {
    await initializeConnection();
    const dbName = process.env.DB_NAME || 'GreetifyDB';
    const tableName = process.env.TABLE_NAME || 'greetings';

    await pool.request().query(`
      IF NOT EXISTS (SELECT * FROM sys.databases WHERE name = '${dbName}')
      BEGIN
          CREATE DATABASE ${dbName};
      END
    `);

    await pool.close();

    const newConfig = getConfig(dbName);
        
    const newPool = new sql.ConnectionPool(newConfig);
    await newPool.connect();

    await newPool.request().query(`
      IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = '${tableName}')
      BEGIN
          CREATE TABLE ${tableName} (
              id BIGINT IDENTITY(1,1) PRIMARY KEY,
              language NVARCHAR(250) NOT NULL UNIQUE,
              greeting NVARCHAR(250) NOT NULL
          );
      END
    `);
    
    console.log(`Database ${dbName} and table ${tableName} initialized successfully!`);
    
    pool = newPool;
    poolPromise = Promise.resolve(newPool);
    
    return newPool;
  } catch (err) {
    console.error('Initialization Error:', err);
    throw err;
  }
}

async function seedDatabase() {

  try {
    const tableName = process.env.TABLE_NAME || 'greetings';
    
    const result = await pool.request().query(`SELECT COUNT(*) as count FROM ${tableName}`);
    
    if (result.recordset[0].count === 0) {
      await pool.request().query(`
        INSERT INTO ${tableName} (language, greeting) VALUES
        (N'English', N'Hello'),
        (N'Spanish', N'Hola'),
        (N'French', N'Bonjour'),
        (N'German', N'Hallo'),
        (N'Italian', N'Ciao'),
        (N'Japanese', N'こんにちは'),
        (N'Chinese', N'你好'),
        (N'Hindi', N'नमस्ते'),
        (N'Russian', N'Привет'),
        (N'Portuguese', N'Olá'),
        (N'Arabic', N'أهلاً'),
        (N'Korean', N'안녕하세요'),
        (N'Dutch', N'Hallo'),
        (N'Swedish', N'Hej'),
        (N'Turkish', N'Merhaba');
      `);
      console.log('Database seeded successfully!');
    } else {
      console.log('Database already contains data, skipping seed.');
    }
    
    const currentData = await pool.request().query(`SELECT * FROM ${tableName}`);
    console.table(currentData.recordset);
  } catch (err) {
    console.error('Seeding Error:', err);
    throw err;
  }
}

export {
  sql,
  pool,
  poolPromise,
  initializeDb,
  initializeConnection,
  seedDatabase
}
