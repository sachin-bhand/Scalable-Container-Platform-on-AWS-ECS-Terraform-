const express = require("express");
const bodyParser = require("body-parser");
const { Pool } = require("pg");
const path = require("path");

const app = express();

app.use(bodyParser.urlencoded({ extended: true }));

// Serve static files
app.use(express.static(path.join(__dirname, "public")));

const pool = new Pool({
  host: process.env.DB_HOST,
  user: process.env.DB_USER,
  password: process.env.DB_PASS,
  database: process.env.DB_NAME,
  port: 5432,
});

// Default route → index.html
app.get("/", (req, res) => {
  res.send("App is working 🚀");
});

app.post("/login", async (req, res) => {
  const { email } = req.body;

  try {
    await pool.query("INSERT INTO users(email) VALUES($1)", [email]);
    res.send("Email saved successfully!");
  } catch (err) {
    console.error(err);
    res.send("Error saving email");
  }
});

app.listen(3000, () => {
  console.log("App running on port 3000");
});