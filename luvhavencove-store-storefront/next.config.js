const { withStoreConfig } = require("./store-config")
const store = require("./store.config.json")

/**
 * @type {import('next').NextConfig}
 */
const nextConfig = withStoreConfig({
  output: "standalone",
  // resolves the '`x-forwarded-host` header with value `localhost` does not match `origin` header with value `localhost:8080` from a forwarded Server Actions request' problem that is happening
  experimental: {
    serverActions: {
      allowedOrigins: [
        "localhost:8080",
        "luvhavencove.com",
        "www.luvhavencove.com"
      ],
    }
  },
  features: store.features,
  reactStrictMode: true,
  images: {
    remotePatterns: [
      {
        protocol: "http",
        hostname: "localhost",
      },
      {
        protocol: "https",
        hostname: "medusa-public-images.s3.eu-west-1.amazonaws.com",
      },
      {
        protocol: "https",
        hostname: "medusa-server-testing.s3.amazonaws.com",
      },
      {
        protocol: "https",
        hostname: "medusa-server-testing.s3.us-east-1.amazonaws.com",
      },
    ],
  },
})

console.log("next.config.js", JSON.stringify(module.exports, null, 2))

module.exports = nextConfig
