const express = require("express");
const sqlite3 = require("sqlite3").verbose();
const bodyParser = require("body-parser");

const app = express();
const db = new sqlite3.Database("db.sqlite");

app.use(bodyParser.json());
app.use(express.static("public"));

// создаём таблицу
db.run(`
CREATE TABLE IF NOT EXISTS stats (
  id TEXT PRIMARY KEY,
  count INTEGER
)
`);

// получить статистику
app.get("/api/stats", (req, res) => {
  db.all("SELECT * FROM stats", (err, rows) => {
    res.json(rows);
  });
});

// клик
app.post("/api/click", (req, res) => {
  const { id } = req.body;

  db.run(`
    INSERT INTO stats (id, count)
    VALUES (?,1)
    ON CONFLICT(id) DO UPDATE SET count = count + 1
  `, [id]);

  res.sendStatus(200);
});

app.listen(3000, () => {
  console.log("🚀 Сервер запущен: http://localhost:3000");
});
