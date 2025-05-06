"use client";

import { useEffect, useState } from "react";
import { TrendingDownIcon, TrendingUpIcon } from "lucide-react";
import { Badge } from "@/components/ui/badge";
import {
  Card,
  CardDescription,
  CardFooter,
  CardHeader,
  CardTitle,
} from "@/components/ui/card";
import { Skeleton } from "@/components/ui/skeleton";
import { getStatusCount } from "@/services/posts";

interface StatusCount {
  total: number;
  raised: number;
  processing: number;
  approved: number;
  rejected: number;
}

export function SectionCards() {
  const [data, setData] = useState<StatusCount | null>(null);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    getStatusCount()
      .then((res) => {
        setData(res);
        setLoading(false);
      })
      .catch(() => {
        setLoading(false);
      });
  }, []);

  const cardData = data
    ? [
        {
          title: "Total Voice Posts",
          description: "Overall submissions",
          value: data.total.toString(),
          badge: {
            text: "+12.5%",
            icon: "up",
          },
          footerMain: "Posts increasing",
          footerSecondary: "Cumulative voice entries",
        },
        {
          title: "Raised Voice Issues",
          description: "Issues raised by users",
          value: data.raised.toString(),
          badge: {
            text: "-20%",
            icon: "down",
          },
          footerMain: "Decrease in new issues",
          footerSecondary: "May indicate resolution",
        },
        {
          title: "Approved Voice Issues",
          description: "Validated by moderators",
          value: data.approved.toString(),
          badge: {
            text: "+12.5%",
            icon: "up",
          },
          footerMain: "High approval rate",
          footerSecondary: "Trusted issue validations",
        },
        {
          title: "Issues in Processing",
          description: "Pending actions",
          value: data.processing.toString(),
          badge: {
            text: "+4.5%",
            icon: "up",
          },
          footerMain: "Processing steadily",
          footerSecondary: "Tracking ongoing resolutions",
        },
      ]
    : [];

  return (
    <div className="*:data-[slot=card]:shadow-xs @xl/main:grid-cols-2 @5xl/main:grid-cols-4 grid grid-cols-1 gap-4 px-4 *:data-[slot=card]:bg-gradient-to-t *:data-[slot=card]:from-primary/5 *:data-[slot=card]:to-card dark:*:data-[slot=card]:bg-card lg:px-6">
      {loading
        ? Array.from({ length: 4 }).map((_, i) => (
            <Card key={i} className="@container/card" data-slot="card">
              <CardHeader>
                <Skeleton className="h-4 w-32 mb-2" />
                <Skeleton className="h-8 w-20 mb-4" />
                <Skeleton className="h-5 w-14 absolute right-4 top-4" />
              </CardHeader>
              <CardFooter className="flex-col items-start gap-1 text-sm">
                <Skeleton className="h-4 w-40 mb-1" />
                <Skeleton className="h-3 w-24" />
              </CardFooter>
            </Card>
          ))
        : cardData.map((card, index) => (
            <Card key={index} className="@container/card" data-slot="card">
              <CardHeader className="relative">
                <CardDescription>{card.description}</CardDescription>
                <CardTitle className="@[250px]/card:text-3xl text-2xl font-semibold tabular-nums">
                  {card.value}
                </CardTitle>
                <div className="absolute right-4 top-4">
                  <Badge
                    variant="outline"
                    className="flex gap-1 rounded-lg text-xs"
                  >
                    {card.badge.icon === "up" ? (
                      <TrendingUpIcon className="size-3" />
                    ) : (
                      <TrendingDownIcon className="size-3" />
                    )}
                    {card.badge.text}
                  </Badge>
                </div>
              </CardHeader>
              <CardFooter className="flex-col items-start gap-1 text-sm">
                <div className="line-clamp-1 flex gap-2 font-medium">
                  {card.footerMain}{" "}
                  {card.badge.icon === "up" ? (
                    <TrendingUpIcon className="size-4" />
                  ) : (
                    <TrendingDownIcon className="size-4" />
                  )}
                </div>
                <div className="text-muted-foreground">
                  {card.footerSecondary}
                </div>
              </CardFooter>
            </Card>
          ))}
    </div>
  );
}
