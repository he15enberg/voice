import {
  AlertCircleIcon,
  AlertTriangleIcon,
  CheckCircleIcon,
  InfoIcon,
} from "lucide-react";

// Return icon based on alert type
export function getStatusIcon(type: string) {
  switch (type) {
    case "Raised":
      return <InfoIcon className="size-5 text-blue-500" />;
    case "Processing":
      return <AlertTriangleIcon className="size-5 text-amber-500" />;
    case "Rejected":
      return <AlertCircleIcon className="size-5 text-red-500" />;
    case "Approved":
      return <CheckCircleIcon className="size-5 text-green-500" />;
    default:
      return <InfoIcon className="size-5  text-blue-500" />;
  }
}
