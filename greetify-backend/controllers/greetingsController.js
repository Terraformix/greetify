import { inMemoryGreetings } from '../data/greetings.js';
import { poolPromise } from '../database/db.js';
import axios from 'axios';
import dotenv from 'dotenv'
import { greetingsClickedCount, greetingsCreatedCount } from '../custom-metrics/metrics.js';
import { serviceConfig } from '../config.js';

dotenv.config();

const getTableName = () => process.env.TABLE_NAME || 'greetings';
const useDb = process.env.USE_DB !== 'false';

const checkIfValidGreetingForLanguage = async(language, greeting, skipValidityCheck) => {
  try {

    const data = {
      language: language.toLowerCase(),
      greeting: greeting.toLowerCase()
    };

    const response = await axios.post(`${serviceConfig.greetifyValidatorServiceUrl}/api/greetings/validate?skipValidityCheck=${skipValidityCheck}`, data);

    if (response.status === 200) {
        return {
          valid: true,
          message: response.data
        };
    }
    

    return {
      valid: false,
      message: response.data || "An error has occured. Please try again later."
    };

  } catch (error) {
    if (error.response && error.response.status === 400) {
        console.log("The greeting is invalid for the specified language.");
    } else {
        console.error("An error occurred:", error);
    }

    return {
      valid: false,
      message: error.response.data || "An error has occured. Please try again later."
    };
  }
}

const checkIfGreetingExists = async (language) => {

  if (useDb) {
    const pool = await poolPromise;
    const result = await pool.request()
      .input('language', language.toLowerCase())
      .query(`SELECT 1 FROM ${getTableName()} WHERE language = @language`);
    return result.recordset.length > 0;
  } else {
    return inMemoryGreetings.some(entry => entry.language.toLowerCase() === language.toLowerCase());
  }
};

const addGreetingToDb = async (language, greeting) => {
  const pool = await poolPromise;

  const insertQuery = `
    INSERT INTO ${getTableName()} (language, greeting)
    OUTPUT Inserted.id
    VALUES (@language, @greeting)
  `;
  
  const insertResult = await pool.request()
    .input('language', language)
    .input('greeting', greeting)
    .query(insertQuery);

  return insertResult.recordset[0]?.id;
};


const addGreetingInMemory = (language, greeting) => {
  const newId = inMemoryGreetings.length + 1;
  inMemoryGreetings.push({ id: newId, language, greeting });
  return newId;
};

const deleteGreetingFromDb = async (id) => {
  const pool = await poolPromise;  
  await pool.request().input('id', id).query(`DELETE FROM ${getTableName()} WHERE id = @id`);
};

const deleteGreetingFromMemory = (id) => {
  const index = inMemoryGreetings.findIndex(g => g.id === id);
  console.log("index", index)
  if (index !== -1) {
    inMemoryGreetings.splice(index, 1);
  }
};

const getAllGreetings = async (req, res) => {
  try {
    if (useDb) {
      const pool = await poolPromise;
      const result = await pool.request().query(`SELECT * FROM ${getTableName()}`);
      return res.json({ greetings: result.recordset });
    } else {
      return res.json({ greetings: inMemoryGreetings });
    }
  } catch (error) {
    console.error('Error fetching greetings:', error.message);
    res.status(500).json({ error: 'Failed to fetch greetings' });
  }
};

const getGreeting = async(req, res) => {

  const { id } = req.params;
  let greeting;

  try {

    if (!id) {
      return res.status(400).json({ error: 'Greeting ID is required.' });
    }
      
    if(useDb) {
  
      const pool = await poolPromise;
      const result = await pool.request().input('id', id).query(`SELECT * FROM ${getTableName()} WHERE id = @id`);
      
      if (result.recordset.length === 0) {
        return res.status(404).json({ error: 'Greeting not found.' });
      }

      greeting = result.recordset[0];
  
      res.status(200).json({
        greeting
      })
    } else {
      
      greeting = inMemoryGreetings.find(x => x.id == id);

      if (!greeting) {
        return res.status(404).json({ error: 'Greeting not found.' });
      }

      res.status(200).json({
        greeting: greeting
      }) 

    }

    greetingsClickedCount.labels(greeting.id, greeting.language, greeting.greeting).inc();
  } catch (error) {
    console.error('Error fetching greeting:', error.message);
    res.status(500).json({ error: `Failed to fetch greeting with id ${id}` });
  }
}

const createGreeting = async (req, res) => {
  try {
    const { language, greeting, skipValidityCheck } = req.body;

    console.log(req.body)

    if (!language || !greeting) {
      return res.status(400).json({ error: 'Language and greeting are required.' });
    }

    const greetingExistsResponse = await checkIfGreetingExists(language);

    if (greetingExistsResponse) {
      return res.status(400).json({ error: 'Greeting for this language already exists.' });
    }

    const validLanguageResponse = await checkIfValidGreetingForLanguage(language, greeting, skipValidityCheck || false);

    if(!validLanguageResponse.valid) {
      return res.status(400).json({ error: validLanguageResponse.message});
    }

    let newId;

    if (useDb) {
      newId = await addGreetingToDb(language, greeting);
    } else {
      newId = addGreetingInMemory(language, greeting);
    }

    greetingsCreatedCount.inc();

    res.status(201).json({
      message: 'Greeting added successfully.',
      data: { id: newId, language, greeting },
      success: true,
    });

  } catch (error) {
    console.error('Error adding greeting:', error.message);
    res.status(500).json({ error: 'Failed to add greeting.' });
  }
};

const deleteGreeting = async (req, res) => {

  const { id } = req.params;

  try {

    if (!id) {
      return res.status(400).json({ error: 'Greeting ID is required.' });
    }

    let success = false;

    if (useDb) {
      const pool = await poolPromise;
      const result = await pool.request().input('id', id).query(`SELECT * FROM ${getTableName()} WHERE id = @id`);
      if (result.recordset.length === 0) {
        return res.status(404).json({ error: 'Greeting not found.' });
      }

      await deleteGreetingFromDb(id);
      success = true;
    } else {
      const index = inMemoryGreetings.findIndex(g => g.id === parseInt(id, 10));
      console.log("index", index)
      if (index === -1) {
        return res.status(404).json({ error: 'Greeting not found in memory.' });
      }

      deleteGreetingFromMemory(id);
      success = true;
    }

    res.status(200).json({
      id: id,
      message: success ? 'Greeting deleted successfully.' : 'Greeting not found.',
      success: success
    });

  } catch (error) {
    console.error('Error deleting greeting:', error.message);
    res.status(500).json({ error: 'Failed to delete greeting.', success: false });
  }
};

export { getAllGreetings, getGreeting, createGreeting, deleteGreeting };
