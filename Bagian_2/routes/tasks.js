const express = require('express');
const router = express.Router();
const authenticateToken = require('../middleware/auth');

router.use(authenticateToken);

/**
 * GET /api/tasks
 * Get all tasks
 * Query params: page (optional), limit (optional) - untuk pagination bonus
 */
router.get('/tasks', async (req, res) => {
  try {
    const pool = req.app.locals.pool;
    const page = parseInt(req.query.page) || 1;
    const limit = parseInt(req.query.limit) || 10;
    const offset = (page - 1) * limit;

    const countResult = await pool.query('SELECT COUNT(*) FROM tasks');
    const total = parseInt(countResult.rows[0].count);

    const result = await pool.query(
      'SELECT * FROM tasks ORDER BY created_at DESC LIMIT $1 OFFSET $2',
      [limit, offset]
    );

    res.status(200).json({
      message: 'Tasks retrieved successfully',
      data: result.rows,
      pagination: {
        page,
        limit,
        total,
        totalPages: Math.ceil(total / limit)
      }
    });
  } catch (error) {
    console.error('Error fetching tasks:', error);
    res.status(500).json({ message: 'Internal server error' });
  }
});

/**
 * GET /api/tasks/:id
 * Get task by ID
 */
router.get('/tasks/:id', async (req, res) => {
  try {
    const pool = req.app.locals.pool;
    const taskId = parseInt(req.params.id);

    const result = await pool.query('SELECT * FROM tasks WHERE id = $1', [taskId]);

    if (result.rows.length === 0) {
      return res.status(404).json({ message: 'Task not found' });
    }

    res.status(200).json({
      message: 'Task retrieved successfully',
      data: result.rows[0]
    });
  } catch (error) {
    console.error('Error fetching task:', error);
    res.status(500).json({ message: 'Internal server error' });
  }
});

/**
 * POST /api/tasks
 * Create new task
 * Body:
 * {
 *   "title": "Task title" (required),
 *   "description": "Task description" (optional),
 *   "status": "pending" or "done" (optional, default: "pending")
 * }
 */
router.post('/tasks', async (req, res) => {
  try {
    const pool = req.app.locals.pool;
    const { title, description, status } = req.body;

    if (!title || title.trim() === '') {
      return res.status(400).json({ message: 'Title is required' });
    }

    if (status && status !== 'pending' && status !== 'done') {
      return res.status(400).json({ 
        message: 'Status must be either "pending" or "done"' 
      });
    }

    const userResult = await pool.query('SELECT id FROM users LIMIT 1');
    const userId = userResult.rows[0]?.id || null;

    const result = await pool.query(
      `INSERT INTO tasks (title, description, status, user_id) 
       VALUES ($1, $2, $3, $4) 
       RETURNING *`,
      [title, description || null, status || 'pending', userId]
    );

    res.status(201).json({
      message: 'Task created successfully',
      data: result.rows[0]
    });
  } catch (error) {
    console.error('Error creating task:', error);
    res.status(500).json({ message: 'Internal server error' });
  }
});

/**
 * PUT /api/tasks/:id
 * Update task (partial update allowed)
 * Body: Any combination of title, description, status
 */
router.put('/tasks/:id', async (req, res) => {
  try {
    const pool = req.app.locals.pool;
    const taskId = parseInt(req.params.id);
    const { title, description, status } = req.body;

    const checkResult = await pool.query('SELECT * FROM tasks WHERE id = $1', [taskId]);
    if (checkResult.rows.length === 0) {
      return res.status(404).json({ message: 'Task not found' });
    }

    if (status && status !== 'pending' && status !== 'done') {
      return res.status(400).json({ 
        message: 'Status must be either "pending" or "done"' 
      });
    }

    const updates = [];
    const values = [];
    let paramIndex = 1;

    if (title !== undefined) {
      updates.push(`title = $${paramIndex++}`);
      values.push(title);
    }
    if (description !== undefined) {
      updates.push(`description = $${paramIndex++}`);
      values.push(description);
    }
    if (status !== undefined) {
      updates.push(`status = $${paramIndex++}`);
      values.push(status);
    }

    if (updates.length === 0) {
      return res.status(400).json({ message: 'No fields to update' });
    }

    updates.push(`updated_at = CURRENT_TIMESTAMP`);
    values.push(taskId);

    const result = await pool.query(
      `UPDATE tasks SET ${updates.join(', ')} WHERE id = $${paramIndex} RETURNING *`,
      values
    );

    res.status(200).json({
      message: 'Task updated successfully',
      data: result.rows[0]
    });
  } catch (error) {
    console.error('Error updating task:', error);
    res.status(500).json({ message: 'Internal server error' });
  }
});

/**
 * DELETE /api/tasks/:id
 * Delete task
 */
router.delete('/tasks/:id', async (req, res) => {
  try {
    const pool = req.app.locals.pool;
    const taskId = parseInt(req.params.id);

    const checkResult = await pool.query('SELECT * FROM tasks WHERE id = $1', [taskId]);
    if (checkResult.rows.length === 0) {
      return res.status(404).json({ message: 'Task not found' });
    }

    await pool.query('DELETE FROM tasks WHERE id = $1', [taskId]);

    res.status(200).json({
      message: 'Task deleted successfully'
    });
  } catch (error) {
    console.error('Error deleting task:', error);
    res.status(500).json({ message: 'Internal server error' });
  }
});

module.exports = router;
