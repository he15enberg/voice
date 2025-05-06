import type { Metadata } from "next";
import { Poppins } from "next/font/google";
import "./globals.css";
import { ThemeProvider } from "@/components/theme-provider";
import { CustomToaster } from "@/components/toast/custom-toaster";

// Import Poppins instead of Geist
const poppins = Poppins({
  variable: "--font-poppins",
  subsets: ["latin"],
  weight: ["400", "500", "600", "700"], // optional: pick weights you want
});

export const metadata: Metadata = {
  title: "Voice",
  description: "An AI-powered issue redreassel system",
};

export default function RootLayout({
  children,
}: Readonly<{
  children: React.ReactNode;
}>) {
  return (
    <html lang="en">
      <body className={`${poppins.variable} font-sans antialiased`}>
        <ThemeProvider
          attribute="class"
          defaultTheme="system"
          enableSystem
          disableTransitionOnChange
        >
          <CustomToaster />
          {children}
        </ThemeProvider>
      </body>
    </html>
  );
}
