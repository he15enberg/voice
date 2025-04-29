// routes/alert.routes.js
import express from "express";
import {
  createAlert,
  getAllAlerts,
  getAlertById,
  updateAlert,
  deleteAlert,
} from "../controllers/alert.controllers.js";

const alertRouter = express.Router();

alertRouter.post("/", createAlert);
alertRouter.get("/", getAllAlerts);
alertRouter.get("/:id", getAlertById);
alertRouter.put("/:id", updateAlert);
alertRouter.delete("/:id", deleteAlert);

export default alertRouter;
