const express = require('express');
const router = express.Router();

const SECRET_TOKEN = process.env.SECRET_TOKEN || 'secret-token-123';

const VALID_EMAIL = 'admin@example.com';
const VALID_PASSWORD = 'password123';

/**
 * POST /api/login
 * Login endpoint untuk mendapatkan token
 * 
 * Body:
 * {
 *   "email": "admin@example.com",
 *   "password": "password123"
 * }
 */
router.post('/login', (req, res) => {
  const { email, password } = req.body;

  if (!email || !password) {
    return res.status(400).json({ message: 'Email and password are required' });
  }

  if (email === VALID_EMAIL && password === VALID_PASSWORD) {
    return res.status(200).json({
      token: SECRET_TOKEN,
      message: 'Login successful'
    });
  }

  return res.status(401).json({ message: 'Invalid credentials' });
});

module.exports = router;
