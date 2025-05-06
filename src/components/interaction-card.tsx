// components/interaction-card.tsx
import React from "react";
import { LucideIcon } from "lucide-react";

export interface InteractionCardProps {
  icon: LucideIcon;
  count: number;
  onClick?: () => void;
}

export const InteractionCard: React.FC<InteractionCardProps> = ({
  icon: Icon,
  count,
  onClick,
}) => {
  return (
    <button className="flex items-center gap-1" onClick={onClick}>
      <Icon className="w-5 h-5" />
      <div className="text-sm text-muted-foreground">{count}</div>
    </button>
  );
};
