/** @type {import('tailwindcss').Config} */
export default {
  content: ["./index.html", "./src/**/*.{js,ts,jsx,tsx}"],
  theme: { extend: { colors: { ink: "#11120f", paper: "#f1efe7", acid: "#d7ff42" }, fontFamily: { display: ["Arial", "sans-serif"] } } },
  plugins: []
};