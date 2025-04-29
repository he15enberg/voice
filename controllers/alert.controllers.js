import Alert from "../models/alerts.model.js";

// Create a new alert
export const createAlert = async (req, res) => {
  try {
    const { title, message, type } = req.body;

    if (!title || !message) {
      return res
        .status(400)
        .json({ message: "Title and message are required" });
    }

    const newAlert = new Alert({ title, message, type });
    const savedAlert = await newAlert.save();

    res
      .status(201)
      .json({
        success: true,
        message: "Alert created successfully",
        data: savedAlert,
      });
  } catch (error) {
    console.error("Error creating alert:", error.message);
    res.status(500).json({ message: "Server error while creating alert" });
  }
};

// Get all alerts
export const getAllAlerts = async (req, res) => {
  try {
    const alerts = await Alert.find().sort({ createdAt: -1 });
    res
      .status(200)
      .json({
        success: true,
        message: "Alert fetched successfully",
        data: alerts,
      });
  } catch (error) {
    console.error("Error fetching alerts:", error.message);
    res.status(500).json({ message: "Server error while fetching alerts" });
  }
};

// Get single alert by ID
export const getAlertById = async (req, res) => {
  try {
    const alert = await Alert.findById(req.params.id);
    if (!alert) return res.status(404).json({ message: "Alert not found" });

    res.status(200).json(alert);
  } catch (error) {
    console.error("Error fetching alert:", error.message);
    res.status(500).json({ message: "Server error while fetching alert" });
  }
};

// Update alert
export const updateAlert = async (req, res) => {
  try {
    const { title, message, type } = req.body;
    const updatedAlert = await Alert.findByIdAndUpdate(
      req.params.id,
      { title, message, type },
      { new: true, runValidators: true }
    );

    if (!updatedAlert)
      return res.status(404).json({ message: "Alert not found" });

    res
      .status(200)
      .json({ message: "Alert updated successfully", alert: updatedAlert });
  } catch (error) {
    console.error("Error updating alert:", error.message);
    res.status(500).json({ message: "Server error while updating alert" });
  }
};

// Delete alert
export const deleteAlert = async (req, res) => {
  try {
    const deleted = await Alert.findByIdAndDelete(req.params.id);
    if (!deleted) return res.status(404).json({ message: "Alert not found" });

    res.status(200).json({ message: "Alert deleted successfully" });
  } catch (error) {
    console.error("Error deleting alert:", error.message);
    res.status(500).json({ message: "Server error while deleting alert" });
  }
};
