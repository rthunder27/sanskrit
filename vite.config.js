import { defineConfig } from 'vite'
import react from '@vitejs/plugin-react'

// https://vitejs.dev/config/
export default defineConfig({
  plugins: [react()],
  server: {
    // Allow access via ngrok tunnels (e.g. for testing on a phone).
    allowedHosts: ['.ngrok-free.dev', '.ngrok-free.app', '.ngrok.io'],
  },
})
