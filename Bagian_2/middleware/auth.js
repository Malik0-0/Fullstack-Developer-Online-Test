const SECRET_TOKEN = process.env.SECRET_TOKEN || 'secret-token-123';

/**
 * Middleware untuk validasi token authentication
 * Semua endpoint kecuali login harus menggunakan token ini
 */
const authenticateToken = (req, res, next) => {
  const authHeader = req.headers['authorization'];
  const token = authHeader && authHeader.split(' ')[1];

  if (!token) {
    return res.status(401).json({ message: 'Unauthorized: Token is required' });
  }

  if (token !== SECRET_TOKEN) {
    return res.status(401).json({ message: 'Unauthorized: Invalid token' });
  }

  next();
};

module.exports = authenticateToken;
