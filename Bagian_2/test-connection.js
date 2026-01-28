require('dotenv').config();
const { Pool } = require('pg');

console.log('Environment variables:');
console.log('DB_HOST:', process.env.DB_HOST);
console.log('DB_PORT:', process.env.DB_PORT);
console.log('DB_NAME:', process.env.DB_NAME);
console.log('DB_USER:', process.env.DB_USER);
console.log('DB_PASSWORD:', process.env.DB_PASSWORD ? '***' : 'NOT SET');

const pool = new Pool({
  host: process.env.DB_HOST || 'localhost',
  port: process.env.DB_PORT || 5432,
  database: process.env.DB_NAME || 'task_management',
  user: process.env.DB_USER || 'postgres',
  password: process.env.DB_PASSWORD || 'postgres',
});

pool.connect()
  .then((client) => {
    console.log('\n✅ Successfully connected to PostgreSQL!');
    return client.query('SELECT current_database(), current_user, version()');
  })
  .then((result) => {
    console.log('\nDatabase Info:');
    console.log('Database:', result.rows[0].current_database);
    console.log('User:', result.rows[0].current_user);
    console.log('Version:', result.rows[0].version.split(',')[0]);
    process.exit(0);
  })
  .catch((err) => {
    console.error('\n❌ Connection failed:');
    console.error('Error:', err.message);
    console.error('\nTroubleshooting:');
    console.error('1. Make sure Docker container is running: docker-compose ps');
    console.error('2. Check if PostgreSQL local is running on port 5432');
    console.error('3. Verify .env file has correct credentials');
    process.exit(1);
  });
