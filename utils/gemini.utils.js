import dotenv from "dotenv";
dotenv.config({ path: "../.env" });

const googleApiKey = process.env.GOOGLE_API_KEY;

import { GoogleGenAI, Type } from "@google/genai";

const ai = new GoogleGenAI({
  apiKey: googleApiKey,
});

export async function isValidIssue(title, description) {
  const prompt = `
You are a smart issue validation assistant for a college campus reporting and redressal system. Your job is to determine whether a user's submitted issue is valid for the system or not.

The system is strictly for handling legitimate issues related to services like:
- Hostel, food, sports, transport, infrastructure, safety, sanitation, and similar real-world concerns on campus.
- Any clear problem, complaint, or request for action related to public or campus services.

Reject the issue if:
- It is offensive, vulgar, abusive, or inappropriate.
- It contains random characters, gibberish, or unclear language.
- It includes jokes, song lyrics, memes, or unrelated internet text.
- It is sarcastic or not serious.
- It is irrelevant to the context of real-world actionable campus issues.
- It is empty, too short to be understood, or not actionable.

Input:
Title: "${title}"
Description: "${description}"

Output format (JSON):
{
  "valid": true or false
}

Return true only if the issue is serious, appropriate, and understandable for reporting and redressal.
`;

  const response = await ai.models.generateContent({
    model: "gemini-2.0-flash",
    contents: prompt,
    config: {
      responseMimeType: "application/json",
      responseSchema: {
        type: Type.OBJECT,
        properties: {
          valid: {
            type: Type.BOOLEAN,
            description: "Whether the issue is valid and reportable.",
            nullable: false,
          },
        },
        required: ["valid"],
      },
    },
  });

  return JSON.parse(response.text).valid; // returns true or false
}

export async function getDomainOfIssue(issueString) {
  const prompt = `
    Classify the following issue description into one of the following domains:
    1. Health & Sanitation Services
    2. Food Services & Canteens
    3. Sports & Recreation Facilities
    4. Animals & Pets Care
    5. Hostel & Accommodation Services
    6. Security & Safety Management
    7. Transport & Campus Infrastructure
    8. Gym, Park & Recreational Areas
    9. Infrastructure Maintenance & Repairs

    Issue Description: "${issueString}"

    Please return the most appropriate domain for the issue.
  `;

  const response = await ai.models.generateContent({
    model: "gemini-2.0-flash", // Use your desired model
    contents: prompt,
    config: {
      responseMimeType: "application/json",
      responseSchema: {
        type: Type.OBJECT,
        properties: {
          domain: {
            type: Type.STRING,
            description:
              "The domain predicted for the given issue description.",
            nullable: false,
          },
        },
        required: ["domain"],
      },
    },
  });

  const predictedDomain = JSON.parse(response.text).domain;
  return predictedDomain;
}

export async function generateSimilarIssueQueries(issueString) {
  const response = await ai.models.generateContent({
    model: "gemini-2.0-flash",
    contents: `Generate 5 slightly varied versions of the following issue description. Each version should preserve the meaning but use different wording. The variations should be similar in meaning but change the wording.

Issue Description: "${issueString}"

Please return these variations as a JSON array of strings.`,
    config: {
      responseMimeType: "application/json",
      responseSchema: {
        type: Type.ARRAY,
        items: {
          type: Type.STRING,
          nullable: false,
        },
      },
    },
  });

  try {
    return JSON.parse(response.text);
  } catch (err) {
    console.error("Failed to parse similar queries:", err);
    return [];
  }
}

export async function isSimilarToPostGroup(newIssue, similarQueries) {
  if (!Array.isArray(similarQueries)) {
    throw new Error("similarQueries must be an array of strings.");
  }

  const prompt = `
You are given a new issue description: "${newIssue}"

Compare this with the following existing queries:
${similarQueries.map((q, i) => `${i + 1}. ${q}`).join("\n")}

Determine if the new issue is semantically similar to any of the queries listed above. 

Similarity here refers to whether they refer to the same kind of problem or belong to the same category of issue, even if worded differently.

Examples:
- "The mess food quality is poor" is similar to "Canteen food is unhygienic"
- "Water leakage in hostel bathroom" is similar to "Hostel bathroom has plumbing issues"

Output 'true' if it is similar to any query. Output 'false' if it is completely different or irrelevant.

Return only a JSON boolean response.
`;

  const response = await ai.models.generateContent({
    model: "gemini-2.0-flash",
    contents: prompt,
    config: {
      responseMimeType: "application/json",
      responseSchema: {
        type: Type.BOOLEAN,
      },
    },
  });

  try {
    return JSON.parse(response.text.trim());
  } catch (err) {
    console.error("Error parsing similarity response:", err);
    return false;
  }
}

export async function generateGroupChatName(similarQueries) {
  if (!similarQueries || similarQueries.length === 0) {
    return JSON.stringify({ groupName: "Group Chat" }); // fallback structured output
  }

  const prompt = `You are given a list of issue descriptions that are similar in meaning. Based on these, generate a short and meaningful title (around 3 to 6 words) that summarizes the issue in simple language.

Return the result strictly as a JSON object with the following format:

{
  "groupName": "your generated title here"
}

Do not include any other text or explanation.

Here are the similar issue descriptions:
${similarQueries.map((q, idx) => `${idx + 1}. ${q}`).join("\n")}
`;

  const response = await ai.models.generateContent({
    model: "gemini-2.0-flash",
    contents: prompt,
    config: {
      responseMimeType: "application/json",
      responseSchema: {
        type: Type.OBJECT,
        properties: {
          groupName: {
            type: Type.STRING,
            nullable: false,
          },
        },
      },
    },
  });

  try {
    return JSON.parse(response.text)["groupName"]; // already JSON string
  } catch (err) {
    console.error("Failed to generate group chat name:", err);
    return "Group Chat";
  }
}

export async function extractIssueDetails(inputText) {
  const locations = [
    "Anna University Main Building",
    "Anna University Swimming Pool",
    "Anna University Central Library",
    "Anna University Hostel",
    "Anna University Main Ground",
    "Anna University Gym",
    "Department of Computer Science & Engineering",
    "Department of Electronics & Communication Engineering",
    "Department of Civil Engineering",
    "Department of Information Science and Technology",
    "Department of Industrial Engineering",
    "Department of Mechanical Engineering",
    "Department of Biotechnology",
    "Department of Nuclear Physics",
  ];

  const prompt = `
You are a helpful assistant in an issue reporting system for Anna University. Extract the issue's title, detailed description, and location from the given text, ONLY if the issue is serious and relevant to real-world campus services like hostel, sanitation, safety, transport, infrastructure, etc.

Rules:
- Reject input if it's inappropriate, sarcastic, a joke, off-topic (like movies or games), gibberish, or cannot be understood clearly.
- Location must strictly match one of the following:

${locations.map((loc) => `- ${loc}`).join("\n")}

Input Text:
"""
${inputText}
"""

Output JSON format:
{
  "success": true or false,
  "data": {
    "title": "short meaningful title of the issue",
    "desc": "clear and complete description",
    "location": "exact match from the approved list"
  }
}

If the text is inappropriate or irrelevant, set "success" to false and do not include the "data" field.
`;

  const response = await ai.models.generateContent({
    model: "gemini-2.0-flash", // or any valid model you're using
    contents: prompt,
    config: {
      responseMimeType: "application/json",
      responseSchema: {
        type: "object",
        properties: {
          success: { type: "boolean" },
          data: {
            type: "object",
            properties: {
              title: { type: "string" },
              desc: { type: "string" },
              location: { type: "string", enum: locations },
            },
            required: ["title", "desc", "location"],
          },
        },
        required: ["success"],
      },
    },
  });

  const result = JSON.parse(response.text);
  return result;
}
await extractIssueDetails("Tap water leak in hostel").then(console.log);
