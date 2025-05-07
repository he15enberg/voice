import mongoose from "mongoose";

const userSchema = new mongoose.Schema(
  {
    name: {
      type: String,
      required: [true, "Admin Name is required"],
      trim: true,
      minLength: 2,
      maxLength: 50,
    },
    email: {
      type: String,
      required: [true, "Admin Email is required"],
      trim: true,
      lowercase: true,
      match: [/\S+@\S+\.\S+/, "Please enter a valid email address"],
    },
    phone: {
      type: String,
      required: [true, "Phone number is required"],
      trim: true,
      match: [/^\d{10,15}$/, "Please enter a valid phone number"],
    },
    password: {
      type: String,
      required: [true, "Password is required"],
      minLength: 6,
    },
    role: {
      type: String,
      enum: ["Student", "Admin"],
      default: "Student",
    },
  },
  { timestamps: true }
);

const User = mongoose.model("User", userSchema);
export default User;
