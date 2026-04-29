import app from "./app";
import { sequelize } from "./config/database";

const PORT = 3000;

const start = async () => {
  try {
    await sequelize.authenticate();
    console.log("DB connected");

    app.listen(PORT, () => {
      console.log(`Server running on http://localhost:${PORT}`);
    });
  } catch (err) {
    console.error(err);
  }
};

start();
