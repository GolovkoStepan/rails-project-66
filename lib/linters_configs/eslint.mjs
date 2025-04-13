import js from "@eslint/js";

export default [
  js.configs.all,
  {
    files: ["**/*.js"],
    languageOptions: {
      ecmaVersion: "latest",
      sourceType: "module",
    }
  },
];
